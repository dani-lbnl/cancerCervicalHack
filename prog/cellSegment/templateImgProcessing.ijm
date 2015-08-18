//Modelo de programa para trabalhar com varias imagens a passarem pelo mesmo kernel:

<initializations>
File.makeDirectory(outputPath); //all your outputs
File.makeDirectory(outputPath+"masks/"); //masks
File.makeDirectory(outputPath+"feat/"); //feats

//Read all the files in the input directory	
FileList = getFileList(inputdir);
start = getTime;
for (k=0;k<N;k++){
		run("Close All");
		print("Processing image "+FileList[k]);
		open(inputdir+FileList[k]); 
		cellRecognition(); 
	}
print("Time of processing=" + d2s(getTime-start,2));

function cellRecognition(){
<your code>
}
