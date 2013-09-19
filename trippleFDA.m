clear

%% Setup materials
steel = material();
steel.E = 210e9;        % Module of elasitcity
steel.v = .3;           % Poisson ration
steel.rho = 7.8e3;      % Density

alum = material();
alum.E = 70e9;
alum.v = .3;
alum.rho = 2.8e3;

carb = material();
carb.E = 1000e9;
carb.v = .3;
carb.rho = 3.0e3;

axis = fdelement('solid');
axis.material = steel;
axis.dimension = 

bushing = fdelement();
bushing.material = carb

house = fdelement();
house.material = alum