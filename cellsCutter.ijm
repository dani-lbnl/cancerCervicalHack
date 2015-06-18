/*Program to cut an image into subimagens containing one cell or cluster of cells of the same type
Algorithm:
1. The user selects an image within the target folder
2. The user selects patches (=subimages) of the sample (=micrograph) and classify 
3. The code will save the images with metadata about the classification and coordinate origin of the crop selection	
Symbols:
 ui_ = user interface
----------------
Created by: Dani Ushizima e Iris Sabino
Modified: Jun 17, 2015
*/

//Customization parameters
var npasses = 50; //max number of images to be cut from a single image
var nbatch = 5;  //number of files processed simultaneously
var separator = File.separator; // it will run on Windows
var inputdir = "/global/scratch/sd/ushizima/als/Empty-Fe-Sand-10x/substack/";
//var inputdir = "/home/ushizima/Documents/Math/ALS/data/xray/nico/sample_emptyFeSand10x/";//"/home/ushizima/Desktop/WinDocs/dani/bkp/2010/ALS/Hornby/";//"/Users/ushizima/Documents/ALS/data/hornby3/";
var outputdir = inputdir+"seg"+separator;
var x_cyl=111;
var y_cyl=111;
var width_cyl=111;
var height_cyl=111;
var bkg_darker = true;
var setCylinder = true;
var FileList;
var items=newArray("Squamous-super","Squamous-inter","Squamous-basal","Squamous-parab","Metaplasia","Endometrial","Endocervical","ASC-H","HSIL","ASC-US","LSIL","AGC","AIS","Adenocarcinoma"); //Claudia
var extension;


macro "Cells_cutter" {
  run("Close All");	
 //Setting quantization param defaults to ImageJ
 run("Options...", "iterations=1 black count=1"); //set black background
 run("Colors...", "foreground=white background=black selection=yellow"); //set colors
 run("Display...", " "); //do not use Inverting LUT
 pathHome = getDirectory("home")
 parts=split(pathHome,"/")
 user = parts[parts.length-1];
 
 inputdir = "/global/scratch/sd/"+user+"/";
 outputdir = inputdir+"seg"+separator;
 
 ui_initialization();
 i=0;

 while(i<FileList.length){     
      if (endsWith(FileList[i], extension)){
          open(inputdir + FileList[i]);
	      //1.open(filename);
	 	  orig = getTitle;
	 	  print("Processing " + orig);
	 	  //2.select patch
	  	  ui_selectPatches(orig); //Patches in Training
		  //3.save metadata
	   	  selectWindow(orig);
	   	  close();	 	   
      }
      i++;
 } 
 	  
	  print("*****Done*****");
} 
*/
//------------------------------------------FUNCTIONS-------------------------------------------------------

/*------------------------------------------
 Initialize parameters with user interaction
 */
function ui_initialization(){
 //Find out stack directory, radix, number of images
  //Find out stack directory, radix, number of images
 Dialog.create("CRIC Project - Cell cutter");
 Dialog.addMessage("Select any image from the target folder");
 Dialog.show();
 open();//open image win to get attributes of the experiment, including folder location
 inputdir = getInfo("image.directory"); 
 outputdir = inputdir+"seg"+separator;
 FileList = getFileList(inputdir)

 //Expects that all the images have the same extension
 fname = getInfo("image.filename");
 parts=split(fname,".");
 n=lengthOf(parts[1]);
 extension = substring(parts[1],0,n); //radix
 close();
 
 Dialog.create("CRIC Project - Cell cutter");
 Dialog.addMessage("Enter configuration settings to process micrographies:\n");
 Dialog.addString("Micrograph folder:",inputdir,60);
 Dialog.addString("Output folder:",outputdir,60);
 Dialog.addString("File extension:",extension,30);
 
 //Dialog.addMessage("Set parameters to process folder with "+FileList.length+" images:\n")
 Dialog.addNumber("Max # subimages",npasses,0,3,"1-50");
 Dialog.addCheckbox("Subset micrograph with ellipses?", true);
 /*
 Dialog.addCheckbox("Boolean classification?",true);
 Dialog.addCheckbox("Keep previous settings?",false);
 
 */
 Dialog.show();
 
 //load selections
 inputdir = Dialog.getString();
 outputdir = Dialog.getString(); 
 extension = Dialog.getString();
 npasses = Dialog.getNumber();
 setCylinder = Dialog.getCheckbox();
 File.makeDirectory(outputdir);
 print("*****Start*****");
 }


/*
 Chop the full image into smaller subimages 
*/
function ui_selectPatches(orig){ 
 j=0;
 bExit = true;
 while( (j<npasses) && (bExit) ){
   selectWindow(orig);
   setTool("oval");	
   xn = round(getWidth/2);
   yn = round(getHeight/2);
   makeOval(xn,yn,xn/2,yn/2);
   waitForUser("Select subimage by adjusting the yellow selector,\n ONLY then, click OK");
   getSelectionBounds(x_patch, y_patch, width_patch, height_patch);
   parts=split(getTitle,".");
   newTitle = parts[0];
   curr_title=newTitle+"_"+j;

   //save that patch
   bExit = fcreatePatch(curr_title,x_patch, y_patch);   
   j++;
   }//end for j samples
  print("Total #subimages="+j);
}

function fcreatePatch(title,x,y){
   other = "?";
   run("Duplicate...","title="+title+" duplicate");
   run("Clear Outside");
   run("Crop");
   run("Make Inverse");
   setForegroundColor(0,0,0);
   run("Fill", "stack");
   run("Select None");
   
   Dialog.create("CRIC Project - Cell cutter");
   Dialog.addMessage("Pap smear micrograph classification:\n");
   Dialog.addChoice("Select class:", items);
   Dialog.addString("Other class:",other,30);
   Dialog.addCheckbox("EXIT THIS MICROGRAPH?",false); 
   Dialog.show();
   choice = Dialog.getChoice();
   other = Dialog.getString();
   if(other == "?")
   		classification = getMetadata + "class=" + choice + "\norigin_subimage=" + x_patch + "," + y_patch;
   else
   		classification = getMetadata + "class=" + other + "\norigin_subimage=" + x_patch + "," + y_patch;
   
   setMetadata("Info", classification);
   bExit = Dialog.getCheckbox();
   
   saveAs("Tiff", outputdir+title+".tif");
   close();	
   return(!bExit);
}   





//Function to save a sequence of processed and segmented images, ignoring top and bottom of substack slices where the segmentation algorithm returns uncertain results
function saveSlices(){	
	run("Select None");
	if (!File.exists(outputdir)) 
		File.makeDirectory(outputdir);	
	nimag_save=0;
	IForeground = getImageID();
	if(nimag==0){
	  run("Make Substack...", "slices=1-"+nbatch);//discard last
	  selectImage(IForeground);close();	
	  run("Image Sequence... ", "format=TIFF name="+filename+" start="+nimag+" digits=3 save=["+outputdir+"]");	
	  
	}else if(nSlices<nbatch){ //if number of slices in current window is smaller than slab
	  nimag_save = nimag+1; //you subtracted at the begining
	  nbatch_save = nSlices; //has less than the other slabs -> the last slab
	  run("Make Substack...", "slices=2-"+nbatch_save);//discard first and last slice
	  selectImage(IForeground);close();	
	  run("Image Sequence... ", "format=TIFF name="+filename+" start="+nimag_save+" digits=3 save=["+outputdir+"]");			
	}
	
	else{
	  nimag_save = nimag+1; //you subtracted at the begining
	  nbatch_save = nbatch +1; //shift by one
	  run("Make Substack...", "slices=2-"+nbatch_save);//discard first and last slice
	  selectImage(IForeground); close();	
	  run("Image Sequence... ", "format=TIFF name="+filename+" start="+nimag_save+" digits=3 save=["+outputdir+"]");
	}	
}

