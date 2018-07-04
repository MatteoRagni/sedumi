function install_sedumi(nopath)

%SeDuMi installation script
%
% This file is part of SeDuMi 1.1 by Imre Polik and Oleksandr Romanko
% Copyright (C) 2005 McMaster University, Hamilton, CANADA  (since 1.1)
%
% Copyright (C) 2001 Jos F. Sturm (up to 1.05R5)
%   Dept. Econometrics & O.R., Tilburg University, the Netherlands.
%   Supported by the Netherlands Organization for Scientific Research (NWO).
%
% Affiliation SeDuMi 1.03 and 1.04Beta (2000):
%   Dept. Quantitative Economics, Maastricht University, the Netherlands.
%
% Affiliations up to SeDuMi 1.02 (AUG1998):
%   CRL, McMaster University, Canada.
%   Supported by the Netherlands Organization for Scientific Research (NWO).
%
% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 2 of the License, or
% (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program; if not, write to the Free Software
% Foundation, Inc.,  51 Franklin Street, Fifth Floor, Boston, MA
% 02110-1301, USA

targets64={...
    'bwblkslv.c sdmauxFill.c sdmauxRdot.c',...
    'choltmpsiz.c',...
    'cholsplit.c',...
    'dpr1fact.c auxfwdpr1.c sdmauxCone.c  sdmauxCmp.c sdmauxFill.c sdmauxScalarmul.c sdmauxRdot.c blkaux.c',...
    'symfctmex.c symfct.c',...
    'ordmmdmex.c ordmmd.c',...
    'quadadd.c',...
    'eigK.c sdmauxCone.c sdmauxRdot.c',...
    'sqrtinv.c sdmauxCone.c',...
    'givensrot.c auxgivens.c sdmauxCone.c',...
    'urotorder.c auxgivens.c sdmauxCone.c sdmauxTriu.c sdmauxRdot.c',...
    'psdframeit.c reflect.c sdmauxCone.c sdmauxRdot.c sdmauxTriu.c sdmauxScalarmul.c',...
    'psdinvjmul.c reflect.c sdmauxCone.c sdmauxRdot.c sdmauxTriu.c sdmauxScalarmul.c blkaux.c',...
    'bwdpr1.c sdmauxCone.c sdmauxRdot.c',...
    'fwdpr1.c auxfwdpr1.c sdmauxCone.c sdmauxScalarmul.c',...
    'fwblkslv.c sdmauxScalarmul.c',...
    'qblkmul.c sdmauxScalarmul.c',...
    'blkchol.c blkchol2.c sdmauxFill.c sdmauxScalarmul.c',...
    'vecsym.c sdmauxCone.c',...
    'qrK.c sdmauxCone.c sdmauxRdot.c sdmauxScalarmul.c',...
    'finsymbden.c sdmauxCmp.c',...
    'symbfwblk.c',...
    'statsK.c sdmauxCone.c',...
    'whichcpx.c sdmauxCone.c',...
    'eyeK.c sdmauxCone.c',...
    'ddot.c sdmauxCone.c sdmauxRdot.c sdmauxScalarmul.c',...
    'makereal.c sdmauxCone.c sdmauxCmp.c',...
    'partitA.c sdmauxCmp.c',...
    'getada1.c sdmauxFill.c',...
    'getada2.c sdmauxCone.c sdmauxRdot.c sdmauxFill.c',...
    'getada3.c spscale.c sdmauxCone.c sdmauxRdot.c sdmauxScalarmul.c sdmauxCmp.c',...
    'adendotd.c sdmauxCone.c',...
    'adenscale.c',...
    'extractA.c',...
    'vectril.c sdmauxCone.c sdmauxCmp.c',...
    'qreshape.c sdmauxCone.c sdmauxCmp.c',...
    'sortnnz.c sdmauxCmp.c',...
    'iswnbr.c',...
    'incorder.c',...
    'findblks.c sdmauxCone.c sdmauxCmp.c',...
    'invcholfac.c triuaux.c sdmauxCone.c sdmauxRdot.c sdmauxTriu.c sdmauxScalarmul.c blkaux.c',...
    };

disp( 'Building SeDuMi binaries...' )
COMPUTER = computer;
VERSION  = sscanf(version,'%d.%d');
IS64BIT  = strcmp(COMPUTER(end-1:end),'64');
flags{1} = '-O';

if ispc
    flags{end+1} = '-DPC';
elseif isunix
    flags{end+1} = '-DUNIX';
end

if IS64BIT
    if (VERSION(1) > 7) || ((VERSION(1)>=7) && (VERSION(2)>=3))
        flags{end+1} = '-largeArrayDims';
    else 
        flags{end+1} = '-DmwIndex=int';
        flags{end+1} = '-DmwSize=int';
        flags{end+1} = '-DmwSignedIndex=int';
    end
end
if ispc
    if (VERSION(1) > 7) || ((VERSION(1)>=7) && (VERSION(2)>=5)) 
        libval = 'blas';
    else
        libval = 'lapack';
    end
    if IS64BIT
        dirval = 'win64'; 
    else
        dirval = 'win32'; 
    end
    
    libs = [ matlabroot, '\extern\lib\', dirval, '\microsoft\libmw', libval, '.lib' ];
    
    if ~exist( libs )
        libs = [ matlabroot, '\extern\lib\', dirval, '\microsoft\msvc60\libmw', libval, '.lib' ];
    end
elseif (VERSION(1) > 7) || ((VERSION(1)>=7) && (VERSION(2)>=5))
    libs = '-lmwblas';
else
    libs = '-lmwlapack';
end

flags = sprintf( ' %s', flags{:} );

for i=1:length(targets64)
    temp =  [ 'mex ', flags, ' ', targets64{i}, ' "', libs ,'"'];
    disp( temp );
    eval( temp );
end
disp( 'Done!' )

if nargin < 1
    disp('Adding SeDuMi to the Matlab path')
    path(path,pwd);
    cd conversion
    path(path,pwd);
    cd ..
    cd examples
    path(path,pwd);
    cd ..
    disp('Please save the Matlab path if you want to use SeDuMi from any directory.');
    disp('Go to File/Set Path and click on Save.');
    disp('SeDuMi has been succesfully installed. For more information type help sedumi or see the User guide.')
end
