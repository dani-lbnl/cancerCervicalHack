/*
 * 
 * This function uses outputs from cervix*.ijm (binary images) to show borders on top of the original images 
 * Created by: 
 * 	Dani Ushizima - dani.lbnl@gmail.com
 * 	03/24/2015
 */

//Input path - dani=laptop, ushizima=desktop
var pathOriginal = "/Users/ushizima/Dropbox/aqui/others/Cervix/isbi2015/data/nossosResultados/testLBNL/EDF/";
var pathRootNucCito = "/Users/ushizima/Dropbox/aqui/others/Cervix/isbi2015/data/nossosResultados/testLBNL/resSPVD_0322/"

macro "visualizeSPVD" {
	
	run("Close All");
	//Output path
	pathOutput = pathRootNucCito + "visualize/";
	File.makeDirectory(pathOutput);
	
	FileList = getFileList(pathOriginal);
	N=FileList.length;
	print(N);
	start = getTime; 
		for (k=0;k<N;k++){
			open(pathOriginal+FileList[k]); //opens the original image
			rename("cinza");
			nImgFile = split(FileList[k],"frame");
			nImgFile = split(nImgFile[0],".");
			nImgFile = nImgFile[0];
			imgFile = "frame"+nImgFile+".tif"; //results save as tif :/ 
			papsmearSeg(imgFile); //main function!!!
			
		}
}


/***************************************************************
* Create borders for nuc and cit to overlay on original image *
***************************************************************/
function papsmearSeg(imgFile){
		
	filename=getTitle();
	//a = fParseFileName(filename);
	if(1==0)
		print("Error open images --- check line 44");
	else{
		
		//mount paths for nuc and cito
		open(pathRootNucCito+"nucleo/"+imgFile);
		rename("nucleo");
		run("Find Edges");
		run("Invert");
		imageCalculator("AND", "cinza","nucleo");
		selectWindow("nucleo");
		run("Invert");
		
		open(pathRootNucCito+"cito/"+imgFile);
		rename("cito");
		run("Find Edges");
		run("Invert");
		imageCalculator("AND", "cinza","cito");
		selectWindow("cito");
		run("Invert");
		//run("Tile");
		wait(100);
		
		//create rgb images with each open image as one channel
	 	run("Merge Channels...", "c1=cito c3=nucleo c4=cinza"); //
	 	saveAs("Tiff", pathOutput+imgFile+".tif");
	 	wait(200);
	 	close();
	 	
	}
	
}
		
	
