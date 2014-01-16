
Equ_Gra = 9.7803253359;                         %  equatorial  gravity
Ecc = 0.081819;                                            %  eccentricity
LAT = 40.40;                                                   %  latitude
Som_C = 0.001931853;                              %  Somigliana’s Constant
G45 = 9.80665;                                             %   gravity at 45.542° N latitude

sur_g = Equ_Gra*(1-Som_C*(sind(LAT))^2)/(1-Ecc^2*(sind(LAT))^2);  %surface gravity
R = 6378.137/(1.006803-0.006706*(sind(LAT))^2);      %  local radius
Z = R/(R*sur_g/G45 -H ); %  geopotential altitude