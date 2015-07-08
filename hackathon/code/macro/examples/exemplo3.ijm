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

//Analisa - note o add to Roi manager
run("Analyze Particles...", "  show=[Count Masks] display clear include add");
//Vai gerar uma image onde tudo vai estar preto... cuidado, o label estah lah mas sua visao nao enxerga
run("3-3-2 RGB");

