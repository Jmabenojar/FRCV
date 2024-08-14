%% SINGLE BEAM MULTIPLE-INTENSITY RECONSTRUCTION (Conventional vs. unordered algorithm)
%  Using simulated data
%  Binamira, Jonel F.
%  February 27, 2019 

% (Note: all units are in meters)

clear all; close all; clc;

%%  Adding the functions needed
% Locates the 'sbmir_functions' and 'sim_images' folder to add the sbmit
% functions in those folders

% addpath(genpath('D:\Darkroom\Jonel\SBMIR files\sim_functions'));
% addpath(genpath('sbmir_functions'));
% addpath(genpath('sim_images'));

%% Generating the object field	

% Loading the image as amplitude
% img =  normed(double((imread('square8.bmp'))),2);
img =  normed(double((imread('square8.bmp'))),2);

% Initializing the parameters
ij = sqrt(-1);  % Imaginary number
[M,N] = size(img); % Array size of the object
delx = 5.2e-6; % x pixel size (camera pitch)
dely = delx; % y pixel size (camera pitch)
lambda = 632.8e-9; % Wavelength
L = M*delx; % Array side length
z_threshold=delx*L/lambda;
disp(z_threshold)
Planes = 10; % Number of observation planes
dz = 3e-3; % Distance between measurement planes

% Generating a diffuser (random array)
rand_arry = rand(M,N);
	
% Setting the coordinates in spatial domain
[X,Y] = meshgrid(-M/2:M/2-1,-M/2:M/2-1);
X = normed(X,1); Y = normed(Y,1);
	
% Initializing the object phase (spherical phase)
R = 352; % height of spherical wave (related to the focal length)
path = (R.^2-(Y).^2-(X).^2);
path_x2 = ((R.^2-(Y).^2-(X).^2))./max(max(R.^2-(Y).^2-(X).^2));
U = (2*pi/lambda)*path_x2;
	
% Simulating the object field (with diffuse ilumination)
randsx = pi; % Diffuser depth of randomization
U = U + rand_arry*randsx; % Add noise to phase
uu = img.*exp(ij*U); % Object field

figure(1); colormap(gray(256));
subplot 121; imagesc(abs(uu)); axis image; title('Object amplitude')
subplot 122; imagesc(angle(uu)); axis image; title('Object phase')


%% Generating intensity measurements

u = zeros(M,M,Planes);      % Store cropped intensity images here
d_0 = 35e-3;    % Distance between plane 1 and the object
dist = zeros(1,Planes); % Store intensity image distances here
ps=0;
% ps = 400; % Pad size
u = padarray(u,[ps,ps],0,'both'); % Places pad on intensity image array

for ii = 1:Planes
    dist(ii) = d_0+(ii-1)*dz; % Propagation distance of the (ii)th plane
    % u(ps+1:M+ps,ps+1:M+ps,ii) = abs(prop_TF(uu,M*delx,lambda,dist(ii))).^2; % Propagation of object to (ii)th plane
    u(ps+1:M+ps,ps+1:M+ps,ii) = abs(proppp(uu,lambda,dist(ii),delx,'ir')).^2;
	u(:,:,ii) = double(uint8(normed(u(:,:,ii),2).*255));
    figure(2); colormap(gray(256)); imagesc(abs(u(ps+1:M+ps,ps+1:M+ps,ii))); axis off; axis image; title(['Intensity image ' num2str(ii)])
    imwrite(uint8(u(ps+1:M+ps,ps+1:M+ps,ii)),['D:\Darkroom\Joshua\mainlatest\SIMULATEDuniverse\simulateddata\s' num2str(ii),'.bmp'])
end; clear ii;
u = u(ps+1:M+ps,ps+1:M+ps,:); % Removes the pad on intensity image array
amps = sqrt(u); % Amplitude