%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Run DICE EVALUATION for segmented images provided by your CODE and available Ground Truth.
%   The program uses a particular directory tree. Keep it in mind in order to generate your
%   results.
%
%   \isbi2014_test\ - main directory of TEST images, GT for Ground Truth, ORIG for
%   Original EDF images and SEG for segmented images using YOUR CODE.

%   \isbi2014_test\GT\Cyto - ground truth directory for cytoplams, one directory for each
%   image from original EDF, where each directory has one binary image for
%   each cytoplasm.

%   \isbi2014_test\GT\Nucleus - ground truth directory for nucleus, one
%   binary image for all nucleus of each image.
%
%  Output: XXXX_dice.dat - dice results saved in file
%
% Created by: Geraldo e Daniel - mar/2015
% Modified by: Andrea Bianchi - jul 2015
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all;
close all;

%%% Variables

inputdir = ['C:\Users\Desktop\figuresteste\isbi2015_edf\'];  % isbi2014_test, isbi2014_train or isbi2015_edf

% Radical from filenames ('cell' for isbi2015 or 'im_' for isbi2014_test/isbi2014_train

seg_name = 'cell';  % im_ or cell   - radical for segmented images in directory
GT_name = 'cell';     % im_ or cell  - radiacal for GT images in directory

%%%% 
%[inputdir 'GT\']

% dir 
diroriginal=[inputdir 'orig\'];
dirGT=[inputdir 'GT\'];
dirseg=[inputdir 'seg\'];

% Cell
cell_aux = [];

% Get number of directories(=cell) in GT
namefiles=dir([dirGT 'Cyto\']);
numfiles=size(namefiles,1); 

%Save GT cyto into a matlab cell
for cont=3:numfiles  %% discart . and .. directories
    
    path_GT_aux = [dirGT 'Cyto\' namefiles(cont,1).name '\'];
    
    clear cell_aux;
    
    for j=1:1000
       try
            [path_GT_aux  GT_name sprintf('%03d',j) '.png'];
            im = imread([path_GT_aux  GT_name sprintf('%03d',j) '.png']);
            cell_aux{j,1} = logical(im);
            
        catch
            if( exist('cell_aux') )
                cvt{(cont-2),1} = cell_aux;
            end
            break;
        end
    end
end

% Get number of directories(=cell) in segmented 

namefiles=dir([dirseg 'Cyto\']);
numfiles=size(namefiles,1); 

%Save segmented files of cyto into a matlab cell
for cont=3:numfiles  %% discart . and .. directories
    
    path_seg_aux = [dirseg 'Cyto\' namefiles(cont,1).name '\'];
    
    clear cell_aux;
    
    for j=1:1000
       try
            [path_seg_aux  seg_name sprintf('%03d',j) '.png'];
            im = imread([path_seg_aux  seg_name sprintf('%03d',j) '.png']);
            cell_aux{j,1} = logical(im);
            
        catch
            if( exist('cell_aux') )
                cvs{(cont-2),1} = cell_aux;
            end
            break;
        end
    end
end

disp('===================================');

%%

display('Calculating ...');
[meanDice FNR meanTPR meanFPR stdDice stdTPR stdFPR STDFN] = evaluateCytoSegmentation(cvt,cvs);

% Save ascii file with results of evaluation

filenamedice=[inputdir 'dice.dat'];
save(filenamedice,'meanDice','stdDice', 'meanTPR', 'stdTPR', 'meanFPR','stdFPR', 'FNR', 'STDFN', '-ascii'); 