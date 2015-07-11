/*
	Program to create accuracy curves for a set of images
	Algorithm:
	1. originalIm <- read original (binary) stack
		nWhiteVoxels = count(originalIm == 255) //positive
		nBlackVoxels = count(originalIm == 0) //negative
	2. nni <- length(noise n = n0:dn:nf)
	3. For i = 1:nni
		noiseIm <- read segmentation of the noisy image i
		tp = count( AND(original,noiseIm) ==255)
		fp = count( AND( (255-original),noiseIm) ==255) //complement of the original
		tpr[i] <- tp/nWhiteVoxels		//true positive rate ; aka hit rate or recall
		fpr[i] <- fp/nBlackVoxels		//false positive rate	; aka fall-out 
		end for
	4. Plot accuracy curve and save file with t, n, tpr and fpr	
	More in: https://en.wikipedia.org/wiki/Precision_and_recall

	Created by Dani Ushizima - dani.lbnl@gmail.com
	07/10/2015
*/
var accValues = newArray(4); //P, N , TP, FP

macro "Evaluation curve [F5]" {
 bplotCurve = true; //plot curve for this code	
 start = getTime;	
 setOption("QueueMacros", true)	
 run("Close All");
 run("Options...", "iterations=1 black count=1"); //set black background
 run("Colors...", "foreground=white background=black selection=yellow"); //set colors
 run("Display...", " "); //do not use Inverting LUT
	
//initializations
 separator = File.separator; 
 //see belownnoise = 9; //number of different sigma values to produce noisy images

//1. read original and calculate number of positives and negatives
 Dialog.create("Evaluation curve");
 Dialog.addMessage("Select any image from the target folder");
 Dialog.show(); 
 open();//open image win to get attributes of the experiment, including folder location
 gtdir = getInfo("image.directory"); 
 dir=substring(gtdir,0,lengthOf(gtdir)-3);
 segmdir = dir+"seg/";
 evaldir = dir+"eval/";
 File.makeDirectory(evaldir);
 FileList = getFileList(gtdir)
 //fname = getInfo("image.filename");
// filename = parseFilename(fname);
 close; //close image win
 
 Dialog.create("Segmentation evaluation"); 
 Dialog.addMessage("Verify paths for the folders below and file numbering! \n");
 Dialog.addString("Ground-truth folder (BW images):",gtdir,70);
 Dialog.addString("Your segm folder (BW images):",segmdir,70);
 Dialog.addString("Your eval folder:",evaldir,70);
// Dialog.addString("Filename prefix:",filename,30);
 Dialog.show();
 //load selections
 print("====================================")
 gtdir = Dialog.getString();
 //print("Ground-truth images in: "+gtdir)
 segmdir = Dialog.getString(); 
 //print("Segm images in folders starting with: "+segmdir)
 evaldir = Dialog.getString();
 //print("Filenames for gt and segm images must have prefix equal to: "+filename);
 //prefix = Dialog.getString();
 
 start = getTime; 
 gtFileList = getFileList(gtdir);
 segmFileList = getFileList(segmdir); //better not two FileList to avoid mismatch of files 
 nFiles = gtFileList.length;
 print("Processing "+nFiles+" files");
 fAcc = File.open(evaldir+"accuracy.txt");
 P = newArray(nFiles); //white pixels on the gt
 N = newArray(nFiles); //black pixels on the gt
 TP = newArray(nFiles); //true positive rate
 FP = newArray(nFiles); //false positive rate
 print(fAcc, "Filename P N TPr FPr");

 for (k=0; k<nFiles; k++){
 	//if( substring(gtFileList[k],0,3) == substring(prefix,0,3) ){
 	 	open(gtdir+gtFileList[k]); 
		filename = getTitle();
		rename("gt"); run("8-bit");
		open(segmdir+segmFileList[k]); 
		rename("segm"); run("8-bit");
		fcheckAccuracy(filename, fAcc); //main function!!!	
		P[k]=accValues[0];
		N[k]=accValues[1];
		TP[k]=accValues[2];
		FP[k]=accValues[3];
  }

 File.close(fAcc);

//4. Plot
 if(bplotCurve){	
 	fplotCurve(TP,FP,nFiles);
 }
 
 print("Time of processing=" + d2s(getTime-start,2));
}

/***************************FUNCTIONS*****/
 function fcheckAccuracy(filename, fAcc){ 	 
	 //calculate p and n
	 selectWindow("gt"); 
	 getHistogram(0,histogram,256); 
	 
	 nWhiteVoxels = histogram[255]; //positives
	 print("P:"+nWhiteVoxels);
	 
	 nBlackVoxels = histogram[0]; //negatives
	 print("N:"+nBlackVoxels);

	 imageCalculator("AND create", "gt", "segm");
	 rename("Image True Positives"); wtp=getTitle;
	 getHistogram(0,histogram,256);
	 truePositives = histogram[255]/nWhiteVoxels;
	 print("TP:"+truePositives);
	 selectWindow("gt");
	 //run("Select All");
	 run("Invert");	
	 imageCalculator("AND create", "gt", "segm");
	 rename("Image False Positives"); wfp=getTitle;
	 getHistogram(0,histogram,256);
	 falsePositives = histogram[255]/nBlackVoxels;
	 print("FP:"+falsePositives);
	 //print results to file
	 print(filename);
	 value = filename +" "+nWhiteVoxels+" "+nBlackVoxels+" "+truePositives+" "+falsePositives;
	 print(fAcc, value);
	 
	 //Closing windows
	 selectWindow("gt");	 close;
	 selectWindow("segm");	 close;
	 selectWindow(wtp);	 close;
	 selectWindow(wfp);	 close;
	 accValues = newArray(nWhiteVoxels,nBlackVoxels,truePositives,falsePositives);
	 
 	 //run("Tile"); 
}

function fplotCurve(TP,FP,nFiles){
		Plot.create("Accuracy curve", "sample file id","positive rate"); //notice you do not put param here, but go adding
 		Plot.setLimits(0, nFiles-1, -0.1, 1.05 );
        Plot.setLineWidth(2);
        Plot.setColor("#005500");
        Plot.add("line", TP);
        Plot.setColor("green");
        Plot.add("circles", TP);
      
        Plot.setColor("#550000");
        Plot.add("line", FP);
        Plot.setColor("red");
        Plot.add("circles", FP);

		setJustification("right");
        Plot.addText("green=TP, red=FP", 1, 0.7);
        
        Plot.show();
}

 
 
 
 
 function StackHistogram(){
 	cumulHist = newArray(256); 
        for (ii=0; ii< nSlices; ii++) { 
                setSlice(ii+1); 
                getHistogram(0,histogram,256);                 
                for (jj = 0; jj < 256; jj++){ 
                        cumulHist[jj]+= histogram[jj]; 
                } 
        }
        return cumulHist;
 }

 function parseFilename(fname){
 	parts=split(fname,".");
 	n=lengthOf(parts[0]);
 	filename = substring(parts[0],0,n); //radix
 	
	nfilename = replace(filename, "[0-9]","AQUI") //find the position of the first number in the string and substitute
	i = indexOf(nfilename,"AQUI") //use the token to find out position 
	return substring(nfilename,0,i) //return substring containing only letters as the filename prefix
 }
