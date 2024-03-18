clear all; close all; clc;
%C. Buco
%last edited: March 31, 2019

clear all; close all; clc;
%% Initializations

lambda = 0.6328/1000; %wavelength
cp = 0.0052;          %pixel pitch
k = 2*pi/lambda;        %wavenumber
nplanes = 15;   %set no. of planes
root = 'C:\Users\Admin\OneDrive - University of the Philippines\MATLAB\CM_codes\THESIS 3\rep_int';
ftype = '.bmp';

%% Load aperture

%%%Simple aperture%%%%%%%%
w = 3.0; %width/diameter
aperture = obj_gen(cp,1024,w,'CIRCLE');

%%%Complex aperture%%%%
% aperture = imread('deca_1024_and 576.jpg');
% aperture = imread('irreg.bmp');
% aperture = imload(aperture);


[M,N] = size(aperture);
% aperture = padarray(aperture, [1024/2-M/2 1024/2-N/2], 'both'); %%if complex aperture, uncomment this
% [M,N] = size(aperture);
% w = M*cp; %if complex aperture, uncomment this

% figure, imshow(mat2gray(crp(aperture,[512 512],650))), axis square; title('Input amplitude')
figure, imagesc(aperture), colormap(gray(255)), axis image;
imwrite(normalize(aperture),colormap(gray(255)),'input_amplitude_irreg.png');%
% imwrite(normalize(crp(aperture,[512 512],650)),colormap(gray(255)),'input_amplitude_irreg.png');%
% save file

% %%  Construct propagator functions
% 
% L = cp*M;  %side length
% x=-L/2:cp:L/2-cp; %spatial coords
% [X,Y]=meshgrid(x,x);
% 
% fx = -1/(2*cp):1/L:1/(2*cp)-1/L;
% [FX,FY] = meshgrid(fx,fx);
% 
% z0 = (ceil(2*cp*(w/2)/lambda))*(1/2); % set distance between object and first plane in mm s.t. the sampling condition is satisfied
% dz = ceil(8*lambda*(z0/(w/2))^2); % set distance between planes in mm
% % % z0 = 44;
% % % dz = 3;
% % 
% %% Create object wave field
% % rr = double(imread('diffuser-1x1.bmp')); %read amplitude diffuser
% % diff_size = 608; %set desired diffuser array size
% % rr = imcrop(rr,[0 0 diff_size diff_size]); %crop to diff_sizexdiff_size array
% % rr = padarray(rr, [M/2-608/2 N/2-608/2], 'both'); %pad zeros to get a CxR array
% rr = (pi/2).*randn(M,N);
% 
% smth = @(ph,n) atan2(conv2(sin(ph),ones(n)/2,'same'),conv2(cos(ph),ones(n)/2,'same'));
% 
% f = -50; %set lens focal length
% ph = phase_gen(M,cp,lambda,'spherical',f); %generate desired phase
% ofield = aperture.*exp(1i*(ph+rr)); %generate complex wave field
% % ofield = rr.*ofield; %act the diffuser on the wave field
% % imwrite(uint8(normalize(crp(smth(angle(ofield),10),[512 512],650))),colormap(gray(255)),[root,'\input_phase_introslide_deca.png']);
% % % imwrite(normalize(angle(exp(1i*ph))),colormap(gray(255)),[root,'\input_phase_introslide.bmp']);
% % figure; imshow(mat2gray(angle(ofield))); axis square; title('Input phase');
% % figure; imagesc(angle(ofield)); colormap(gray(255)); axis image; title('Input phase');
% % % figure; imagesc(angle(exp(1i*ph))); colormap(gray); axis square; title('Input phase');
% %   
% %% Intensity Recording
% 
% AS = @(dist) fftshift(exp(-1i*k*dist.*sqrt(1-(lambda.*FX).^2-(lambda.*FY).^2)));
% prop = @(u,AS) ifftshift(ifft2(fft2(fftshift(u)).*AS));
% 
% for i = 1:nplanes;
%     z = z0+(i-1)*dz;  %input distance
%     Sforward = AS(z);
%     pfield = prop(ofield,Sforward);
%     int = pfield.*conj(pfield); % get intensity
%     int = normalize(int); % normalize to gray value (0 to 255)
%     imwrite(imadjust(mat2gray(int)),[root, '\u_', num2str(i), '.bmp']);
% %     imwrite(int,colormap(hot),[root, '\u_', num2str(i), '.bmp']);
% %     imwrite(uint8(int),[root, '\u_', num2str(i), '.bmp']);
% %     figure(101); imshow(mat2gray(int)); axis square; drawnow;
% end
% % % % % 
% % % % % % % % Sf = AS(z0);
% % % % % % % % u_field = prop(ofield,Sf);
% % % % % % % 
% % % % % % % % %% Focus measurement
% % % % % % % % fv_grae = [];
% % % % % % % % fv_glva = [];
% % % % % % % % fv_lape = [];
% % % % % % % % fv_ten = [];
% % % % % % % % for ii=1:0.10:20;
% % % % % % % %     zz = ii;
% % % % % % % %     Sbo = AS(-zz);
% % % % % % % % %     u_field = ifftshift(ifft2(fft2(fftshift(amps(:,:,1).*exp(1i*phase))).*(Sbo)));
% % % % % % % %     ufield = prop(u_field,Sbo);
% % % % % % % %     fval_grae = fmeasure(abs(ufield).^2,'GRAE');
% % % % % % % %     fval_glva = fmeasure(abs(ufield).^2,'GLVA');
% % % % % % % %     fval_lape = fmeasure(abs(ufield).^2,'LAPE');
% % % % % % % %     fval_ten = fmeasure(abs(ufield).^2,'TENG');
% % % % % % % %     fv_grae = [fv_grae;fval_grae];
% % % % % % % %     fv_glva = [fv_glva;fval_glva];
% % % % % % % %     fv_lape = [fv_lape;fval_lape];
% % % % % % % %     fv_ten = [fv_ten;fval_ten];
% % % % % % % % end
% % % % % % % % fv_grae = (fv_grae-min(fv_grae))./(max(fv_grae)-min(fv_grae));
% % % % % % % % fv_glva = (fv_glva-min(fv_glva))./(max(fv_glva)-min(fv_glva));
% % % % % % % % fv_lape = (fv_lape-min(fv_lape))./(max(fv_lape)-min(fv_lape));
% % % % % % % % fv_ten = (fv_ten-min(fv_ten))./(max(fv_ten)-min(fv_ten));
% % % % % % % % figure; hold on
% % % % % % % % plot(1:0.10:20,fv_grae,'r-');
% % % % % % % % plot(1:0.10:20,fv_glva,'b-');
% % % % % % % % plot(1:0.10:20,fv_lape,'g-');
% % % % % % % % plot(1:0.10:20,fv_ten,'y-');
% % % % % % % % legend('grae','glva','lape','teng');