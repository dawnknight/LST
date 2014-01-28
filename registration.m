clc
clear

path = 'C:\Users\atc327\Dropbox\LST\L45 TM\';
FolderList=dir(path);

for i = 3:length(FolderList)
    %% data info extract
    SubFolder = FolderList(i).name;
    SubPath = [path SubFolder '\'];
    MTL_file=dir([SubPath,'*_MTL.txt']);
    [LAT,LON]= coordinate_extract(SubPath,MTL_file.name);  %unit : sec
    ImList = dir([SubPath,'*.TIF']);
    %% input img
    f = imread([ SubPath ImList(1).name]);
    [m,n] = size(f);
    %% image coners extract
    f_u =  f(1:150,1:round(n/2),:);
    f_l = f(m-149:m,round(n/2):n,:);
    C_u = sortrows(corner(f_u),2);
    C_l = sortrows(corner(f_l),2);
    UL = [C_u(1,1),C_u(1,2)];                                                % UL coner [x,y]
    LR = [C_l(end,1)+round(n/2),C_l(end,2)+m-149];   % LR coner [x,y]


    %% target region setting  (NYC region)

    T_LAT = [40.8755,40.4916];   %upper-bound,lower-bound % taget region LAT
    T_LON = [-74.2653,-73.7478];  % left--bound,right-bound  % taget region LON
    T_LAT = T_LAT*3600;
    T_LON = T_LON*3600;

%%
    if iscover(LON,LAT,T_LON,T_LAT) ;
 %% img cut extract
        y_step = (UL(1)-LR(1))/(LAT(1)-LAT(4));                %unit : pixel/sec
        x_step = (UL(2)-LR(2))/(LON(1)-LON(4));             %unit : pixel/sec
        T_Yu = UL(1) +(T_LAT(1)-LAT(1))*y_step;                       %taget region's y coordinate (upper-bound)
        T_Yl  =  UL(1) +(T_LAT(2)-LAT(1))*y_step;                       %taget region's y coordinate (lower-bound)
        T_Xl =   UL(2) + (T_LON(1)-LON(1))*x_step;                     %taget region's x coordinate (left-bound)
        T_Xr  =  UL(2) + (T_LON(2)-LON(1))*x_step;                    %taget region's x coordinate (right-bound)

        %% img show
        figure,imshow(f(T_Yu:T_Yl,T_Xl:T_Xr,:))
    else
        msg = sprintf('img of %s is out of range!!',FolderList(i).name)
    end
end



