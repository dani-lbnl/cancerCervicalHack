/*
 * This macro reads training data and extract features of the cells to perform feature inference on unseen samples 
 * 1. read the original image 
 * 2. read nucleus and citoplasm (notice that the assumption here is that there's no dependency between the nucleus and the cytoplasm it depends upon
 * 3. mask nucleus and extract features
 * 4. mask cytoplasm and extract features
 * 
 * Created by: 
 * 	Dani Ushizima - dani.lbnl@gmail.com
 * 	03/24/2015	
 */

//Input path - ushizima=cafofo, dani=trampo
	var username="ushizima";
	
	//binary images from the conference
	//var pathRoot = "/Users/"+username+"/Dropbox/aqui/others/Cervix/ISBI2015/data/imagensOriginais/Training_R1_01Dec2014/Training/"
	var pathRoot = "/Users/"+username+"/Dropbox/aqui/others/Cervix/ISBI2015/data/imagensOriginais/Training_R2_Jan2015/"
	
	//graylevel images
	var pathOriginal = pathRoot + "EDF/";
	//binary images from the conference
	var pathRootNuc = pathRoot + "NucleusGT/frame";
	var pathRootCito =  pathRoot + "seg_frame";

//Output
	var pathOutput = "/Users/ushizima/Dropbox/aqui/others/Cervix/ISBI2015/data/nossosResultados/testLBNL/trainingFeatures/";

macro "featureExtractionNucCit" {
	
	run("Close All");
	//Output path
	File.makeDirectory(pathOutput);
	
	FileList = getFileList(pathOriginal);
	N=FileList.length;
	print(N);
	
	start = getTime; 	
	
		for (k=0;k<N;k++){
			//open original EDF image
			open(pathOriginal+FileList[k]); rename("orig");
			nImgFile = split(FileList[k],"frame");
			nImgFile = split(nImgFile[0],".");
			nImgFile = nImgFile[0];
			//imgFile = "frame"+nImgFile+".tif"; //results save as tif :/ 
			open(pathRootNuc+nImgFile+ "_NUGT.png"); rename("nuc");
			run("8-bit");	
			
			print(pathRootCito+nImgFile+"_png/"); 
			FileListCito = getFileList(pathRootCito+nImgFile+"_png/");
			Ncito=FileListCito.length;

			//Settings for feature extraction - must be within for(k because depends on the images
			run("Set Measurements...", "area mean standard modal min centroid center perimeter bounding fit shape feret's integrated median skewness kurtosis area_fraction limit redirect=orig decimal=4");
			//run("Analyze Particles...", "display clear in_situ");
			run("Analyze Particles...", "size="+0+"-Infinity pixels circularity=0.00-1.00 display clear in_situ");//100=40microns
			saveAs("Results", pathOutput+ "featNuc" + nImgFile + ".xls");
			wait(100);
			selectWindow("nuc");close;
			selectWindow("Results");run("Close");
			//f= File.open(pathOutput+"featNuc"+nImgFile+".txt");
			
			//for each cytoplasm
			for (c=0;c<Ncito;c++){
				open(pathRootCito+nImgFile+"_png/"+FileListCito[c]);
				run("8-bit");
				rename("cito");
				run("Analyze Particles...", "size="+0+"-Infinity pixels circularity=0.00-1.00 display in_situ");
				wait(100);
				selectWindow("cito");close;
			}
			saveAs("Results", pathOutput+ "featCito" + nImgFile + ".xls");
			wait(100);
			selectWindow("orig");close;
			selectWindow("Results");run("Close");			
		}
		
}		
	
