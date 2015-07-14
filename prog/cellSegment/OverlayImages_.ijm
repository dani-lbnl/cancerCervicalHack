/*
 * Macro to overlay segmentation results and visually show precision of the method 
 * This examples use a Fiji sample
 * 
 *  Dani Ushizima - dani.lbnl@gmail.com
*  Create 09/10/2013
*  Modified 07/14/2015
 */

macro "overlay_result"{
	
	/*Dialog.create("Overlay two images:"); 
 	Dialog.addMessage("** Enter parameters to process, segment and save Pap smear images: **\n");
 	Dialog.addString("Raw data to be the image-basis: ", image1,40);
 	Dialog.addString("Binary data to be the edges of image-basis: ",image2,40);
 	Dialog.show();
 	*/
 	
 	run("Dot Blot (7K)");
 	image1 = getTitle();
 	run("Duplicate...","title=borders");
 	image2 = getTitle();
 	
 	
	selectWindow(image2); 
	setThreshold(128,255);
	run("Convert to Mask");
	run("Find Edges");
	run("Find Connected Regions", "allow_diagonal display_one_image regions_for_values_over=100 minimum_number_of_points=1 stop_after=-1");
	run("RGB Color");
	image3 = getTitle();
	selectWindow(image1);
	run("RGB Color");

	//imageCalculator("AND", "original","halo"); //mark in black the borders of clump
	imageCalculator("Transparent-zero create", image1,"All connected regions");
}
