function [x,y]= coordinate_extract(fpath,fname)
 x = zeros(4,1);
 y=x;
 fid = fopen([fpath fname]) ;
 index = fgetl(fid);                                             %UL_LAT
 while isempty(findstr(index,'CORNER_UL_LAT_PRODUCT'))
            index = fgets(fid);
 end
 x(1)= str2num(index(29:end));
 
 fid = fopen([fpath fname]) ;
 index = fgetl(fid);                                             %UL_LON
 while isempty(findstr(index,'CORNER_UL_LON_PRODUCT'))
            index = fgets(fid);
 end
  y(1)= str2num(index(29:end));
 
 fid = fopen([fpath fname]) ;
  index = fgetl(fid);                                             %UR_LAT
 while isempty(findstr(index,'CORNER_UR_LAT_PRODUCT'))
            index = fgets(fid);
 end
  x(2)= str2num(index(29:end));
 
 fid = fopen([fpath fname]) ;
 index = fgetl(fid);                                             %UR_LON
 while isempty(findstr(index,'CORNER_UR_LON_PRODUCT'))
            index = fgets(fid);
 end
  y(2)= str2num(index(29:end));
 
 fid = fopen([fpath fname]) ;
  index = fgetl(fid);                                             %LL_LAT
 while isempty(findstr(index,'CORNER_LL_LAT_PRODUCT'))
            index = fgets(fid);
 end
  x(3)= str2num(index(29:end));
 
 fid = fopen([fpath fname]) ;
 index = fgetl(fid);                                             %LL_LON
 while isempty(findstr(index,'CORNER_LL_LON_PRODUCT'))
            index = fgets(fid);
 end
  y(3)= str2num(index(29:end));
 
 fid = fopen([fpath fname]) ;
  index = fgetl(fid);                                             %LR_LAT
 while isempty(findstr(index,'CORNER_LR_LAT_PRODUCT'))
            index = fgets(fid);
 end
  x(4)= str2num(index(29:end));
 
 fid = fopen([fpath fname]) ;
 index = fgetl(fid);                                             %LR_LON
 while isempty(findstr(index,'CORNER_LR_LON_PRODUCT'))
            index = fgets(fid);
 end
  y(4)= str2num(index(29:end));
  
  x = x*3600;
  y = y*3600;
 

 