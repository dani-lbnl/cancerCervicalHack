/************************
 * This is only a piece of the algorithm that won ISBI 2014
 */

BF_range = 30;
SRM_q=25;
Phansalkar_r = 15; //less brings less nucleus material

minSize = 150; //as in the training set will miss 8 nuc 
minSizeCito = 2500;
bsave = true

//Default desired behavior
	setOption("QueueMacros", true);
	run("Options...", "iterations=1 black count=1"); //set black background
 	run("Colors...", "foreground=white background=black selection=yellow"); //set colors
 	run("Display...", " ");
//	run("Close All"); 	

rename("Original");		
		/************************
		 * Getting the clump
		 ***********************/
		 
		run("Bilateral Filter", "spatial=3 range="+BF_range);
		run("Enhance Local Contrast (CLAHE)", "blocksize=127 histogram=256 maximum=3 mask=*None* fast_(less_accurate)");
		rename("Filtered");
		//Recover pixels that are most likely to belong to the cytoplasm
		selectWindow("Filtered");
		//Calculate superpixel
		run("Statistical Region Merging", "q="+SRM_q+" showaverages");
		run("8-bit");
		rename("srm");
		run("Duplicate...","title=Clump");
		setAutoThreshold("Triangle"); //this is going to screw real data 
		run("Convert to Mask");
		//Eliminate borders which were corrupted by the bilateral filter
		newIntensity = 0;
		for(i=0;i<getWidth;i++){
			setPixel(i,0,newIntensity);
			setPixel(i,getHeight-1,newIntensity);
		}
		for(i=0;i<getHeight;i++){
			setPixel(0,i,newIntensity);
			setPixel(getWidth-1,i,newIntensity);
		}
			
		run("Analyze Particles...", "size="+minSize+"-Infinity pixels circularity=0.0-1.00 show=Masks in_situ");
		//Create a halo around cells = clump   
		for (i=0;i<10;i++)
			run("Dilate");
		wait(100);	
		//Code below is only for visualization purposes
		//run("Duplicate...","title=halo");
		//run("Find Edges"); run("Invert"); //halo will appear as a dark 
		
		/*
		selectWindow("Original");
		run("Bilateral Filter", "spatial=3 range=20");
		rename("Original_bf");
		
		imageCalculator("AND create", "Original_bf","Clump"); //cannot mask clump with srm because some nuc are 0, therefore the same color as background!
		rename("Clump_masked");
		
		selectWindow("Clump");  
		
		run("Invert"); 
		imageCalculator("add", "Clump_masked","Clump"); //because black background will penalize black nuclear material!
		selectWindow("Clump_masked"); 
		run("Duplicate...","title=ToBeNuc");
		*/