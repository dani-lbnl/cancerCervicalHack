//input
run("Close All");
stack ="frame004_stack";
run("Image Sequence...", "open=/Users/ushizima/Dropbox/aqui/others/Cervix/ISBI2015/data/Training_R1_01Dec2014/Training/"+stack+" sort");
win = getTitle;
outputdir = "/Users/ushizima/Dropbox/aqui/others/Cervix/ISBI2015/data/Results/"+stack+"/";
File.makeDirectory(outputdir);

//Potential to get nuc + cell mass
selectWindow(win);
run("Z Project...", "projection=[Sum Slices]");
saveAs("Tiff", outputdir+"sum.tif");

//
selectWindow(win);
run("Z Project...", "projection=Median");
saveAs("Tiff", outputdir+"median.tif");

selectWindow(win);
run("Z Project...", "projection=[Average Intensity]");
saveAs("Tiff", outputdir+"avg.tif");

//Highest sd at the borders - can we use this as input to canny?
selectWindow(win);
run("Z Project...", "projection=[Standard Deviation]");
saveAs("Tiff", outputdir+"sd.tif");
//run("Enhance Contrast...", "saturated=0.4 normalize");

//Bacterial flora and small debris
selectWindow(win);
run("Z Project...", "projection=[Min Intensity]");
saveAs("Tiff", outputdir+"min.tif");

//Background estimation? not sure we need this
selectWindow(win);
run("Z Project...", "projection=[Max Intensity]");
saveAs("Tiff", outputdir+"max.tif");

run("3D Surface Plot");
//run("Calculator Plus", "i1=SUM_frame000_stack i2=MED_frame000_stack operation=[Subtract: i2 = (i1-i2) x k1 + k2] k1=64 k2=0 create");