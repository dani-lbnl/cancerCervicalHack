/*
 * This is an example of applying threshold and calculate edges
 */
setAutoThreshold("Otsu");
//setThreshold(0, 203);
setOption("BlackBackground", true);
run("Convert to Mask");
run("Find Edges");

