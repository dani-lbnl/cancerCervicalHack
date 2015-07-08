/*
 * Evaluation criteria for cervical cell segmentation
 * 
 * Daniela Ushizima - dani.lbnl@gmail.com
 */
image_path = "/Users/ushizima/Dropbox/aqui/others/Cervix/eventos/hackathon/images/subset/";
code_path = "/Users/ushizima/Dropbox/aqui/others/Cervix/eventos/hackathon/code/";

run("Macro... ", "input="+image_path+" output="+image_path+"seg"+" open="+code_path+"exemplo1.ijm");