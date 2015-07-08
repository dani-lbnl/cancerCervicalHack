//Cria uma image simples pra teste
newImage("MeuTeste", "8-bit white", 500, 500, 1);
run("Undo");
//setTool("oval");
makeOval(84, 97, 119, 130);
run("Cut");
makeOval(296, 235, 121, 143);
run("Cut");
run("Select None");
run("Invert");

run("Find Connected Regions", "allow_diagonal display_image_for_each regions_for_values_over=100 minimum_number_of_points=1 stop_after=-1");
