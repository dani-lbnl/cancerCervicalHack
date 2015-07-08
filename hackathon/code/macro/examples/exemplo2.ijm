/*
 * This is an example of analysis 
 */
run("Close All");	
run("Cell Colony (31K)");
title = "seg";
run("Duplicate...","title="+title+" duplicate");
setAutoThreshold("Otsu");
//setThreshold(0, 203);
setOption("BlackBackground", true);
run("Convert to Mask");
run("Set Measurements...", "area mean standard modal min centroid center perimeter bounding fit shape feret's integrated median skewness kurtosis area_fraction redirect=Cell_Colony.jpg decimal=2");
run("Analyze Particles...", "display exclude clear include in_situ");
