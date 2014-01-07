function output = k2RGB(Kmap)
% @author: andy chiang
% convert Kelvin temperature into RGB domain
% input is an N by M image
% output is an N by M by 3 color image

% tic
[m,n] = size(Kmap);
Rmap = zeros(m,n);
Gmap = zeros(m,n);
Bmap = zeros(m,n);

Kmap = Kmap / 100;

Rmap(Kmap<=66) = 255;
Rmap(Kmap>66) = Kmap(Kmap>66)-60;
Rmap(Kmap>66) = 329.69827446*Rmap(Kmap>66).^-0.1332047592;
Rmap(Rmap>255) =255;
Rmap(Rmap<0) =0;

Gmap(Kmap<=66) = Kmap(Kmap<=66);
Gmap(Kmap<=66) = 99.4708025861*log(Gmap(Kmap<=66)) -161.1195681661;  
Gmap(Kmap>66) = Kmap(Kmap>66)-60;
Gmap(Kmap>66) = 288.1221695283*Gmap(Kmap>66).^-0.0755148492;
Gmap(Gmap>255) =255;
Gmap(Gmap<0) =0;

Bmap(Kmap>=66) = 255;
Bmap(Kmap<=19) = 0;
Bmap(Kmap<66&Kmap>19) = Kmap(Kmap<66&Kmap>19)-10;
Bmap(Kmap<66&Kmap>19) = 138.5177312231*log(Bmap(Kmap<66&Kmap>19))-305.0447927307;
Bmap(Bmap>255) =255;
Bmap(Bmap<0) =0;

output = Rmap;
output(:,:,2) = Gmap;
output(:,:,3) = Bmap;