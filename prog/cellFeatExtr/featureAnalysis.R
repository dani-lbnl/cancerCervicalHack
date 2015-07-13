#Processing the features from features.ijm
#Dani Ushizima - dani.lbnl@gmail.com
#

require(gdata)

#my inputs
pathOutput = "/Users/ushizima/Dropbox/aqui/others/Cervix/ISBI2015/data/nossosResultados/testLBNL/trainingFeatures/feat";
fnames=c('Nuc','Cito')

#read nuc and cito
for (i in 1:2){
  sample = NULL
  files = Sys.glob(paste(pathOutput,fnames[i],"*.xls",sep=''));
  for (j in 1:length(files)){
    sample = rbind(sample,read.table(files[j],header=T));
  }
  if(i == 1)
    nuc = sample; 
}


#just in case R crashes, which happened before
write.csv(nuc, file=paste(pathOutput,"allNuc.csv",sep=''), row.names=F);
write.csv(sample, file=paste(pathOutput,"allCito.csv",sep=''),row.names=F);

require(car)
scatterplotMatrix(nuc[,c(1,11,14,15,19)])
