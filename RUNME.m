close all; clear all; clc;

lambda = 632.8e-9; %wavelength
cp = 5.2e-6;          %pixel pitch
k = 2*pi/lambda;      %wavenumber             

num = 5;              %number of images
% Hi sir palitan niyo lang po yung 
%'D:\Darkroom\Joshua\' to directory ng folder niyo
root='D:\Darkroom\Joshua\mainlatest\'; % <--- PAPALITAN TO
%% dz=3mm data
% root_from = [root 'FRCV\exp_data\u'];     %file root to get images
% firstplane=16         % First plane used
% z0 = 44e-3;             % first plane distance of the original data
% dz = 3e-3;             %distance between measurement planes (experimental)
% z0=z0+dz*(firstplane-1); % ADJUSTED first plane distance depending on selected firstplane


%% dz=12mm data
firstplane=4         % First plane used
root_from = [root 'FRCV\exp_data\exp_data12mm' num2str(firstplane) '\u'];     %file root to get images
z0 = 44e-3; %z0 if first plane is 1
dz=3e-3;       % Default dz
z0=z0+dz*(firstplane-1); % z0 based on the first plane            
dz = 12e-3;             %distance between measurement planes (experimental)


%% Folders for reconstructced images(Don't edit)
root_to1 = [root 'FRCV-results\AS']; % RS Convolution method
% root_to2 = [root 'FRCV-results\TF'];
root_to3 = [root 'FRCV-results\IR']; % Proposed method
ftype = '.bmp';       %file type

%% Read intensities
centr = [550 670]; %locate cropping center (experimental data)
arrysize = 800; %desired cropped array size 

uu = zeros(2*floor(arrysize/2),2*floor(arrysize/2),num); %create an empty array to save intensities

for ii = 1:num % Read intensities
   int = (imread([root_from int2str(firstplane+ii-1) ftype])); 
   int = (double(int)); %convert to double precision
   uu(:,:,ii) = crp(int,centr,arrysize); %comment if cropping is unnecessary
   % figure(101); imagesc(uu(:,:,ii)); colormap(gray(255)); axis image;
end
amps = sqrt(uu); %calculate the amplitude from intensity(Input ng SBMIR)



%% Comparison
%smoothing function for display
smth = @(ph,n) atan2(conv2(sin(ph),ones(n)/2,'same'),conv2(cos(ph),ones(n)/2,'same'));

iter = 170; %set the number of iterations

load r2; % load a guess phase (better for experimental data)
phase = padarray(phase, [arrysize/2-512/2 arrysize/2-512/2], 'both'); 

%% SBMIR
[u_rec_sbmir,tFB,mse_amp_fb,mse_ph_fb] = sbmir(lambda,cp,dz,z0,num,iter,amps,phase,root_to1,'as'); % execute sbmir
disp(['ASM: Iterations: ',num2str(length(mse_amp_fb)-1), ...
    ' ; time: ',num2str(tFB), ' s']); %display execution time

 % get the reconstructed amplitude and phase
ampFB = abs(u_rec_sbmir); 
phFB = angle(u_rec_sbmir);
%crop
ampFB = crp(ampFB,[arrysize/2 arrysize/2],600); 
phFB = crp(smth(phFB,10),[arrysize/2 arrysize/2],600); 

%% TF
% [u_rec_sbmir2,tFB2,mse_amp_fb2,mse_ph_fb2] = sbmir(lambda,cp,dz,z0,num,iter,amps,phase,root_to2,'tf'); % execute sbmir
% disp(['TF: Iterations: ',num2str(length(mse_amp_fb2)-1), ...
%     ' ; time: ',num2str(tFB2), ' s']); %display execution time
% 
% 
%  % get the reconstructed amplitude and phase
% ampFB2 = abs(u_rec_sbmir2); 
% phFB2 = angle(u_rec_sbmir2);
% %crop
% ampFB2 = crp(ampFB2,[arrysize/2 arrysize/2],600); 
% phFB2 = crp(smth(phFB2,10),[arrysize/2 arrysize/2],600); 
%% IR
[u_rec_sbmir3,tFB3,mse_amp_fb3,mse_ph_fb3] = sbmir_fc(lambda,cp,dz,z0,num,iter/2,amps,phase,root_to3,'ir'); % execute sbmir
disp(['IR: Iterations: ',num2str(length(mse_amp_fb3)-1), ...
    ' ; time: ',num2str(tFB3), ' s']); %display execution time

 % get the reconstructed amplitude and phase
ampFB3 = abs(u_rec_sbmir3); 
phFB3 = angle(u_rec_sbmir3);
%crop
ampFB3 = crp(ampFB3,[arrysize/2 arrysize/2],600); 
phFB3 = crp(smth(phFB3,10),[arrysize/2 arrysize/2],600); 
%% Save plots to excel sheets
delete('mseplots_amp_sbmir.xlsx');
xlswrite('mseplots_amp_sbmir.xlsx',transpose(1:length(mse_amp_fb)-1),'Sheet1',['A2:A' num2str(length(mse_amp_fb))]);
xlswrite('mseplots_amp_sbmir.xlsx',mse_amp_fb(2:length(mse_amp_fb)),'Sheet1','B2');
xlswrite('mseplots_amp_sbmir.xlsx',mse_amp_fb3(2:length(mse_amp_fb3)),'Sheet1','C2');
% xlswrite('mseplots_amp_sbmir.xlsx',mse_amp_fb2(2:length(mse_amp_fb2)),'Sheet1','D2');
% Phase plots
delete('mseplots_ph_sbmir.xlsx');
xlswrite('mseplots_ph_sbmir.xlsx',transpose(1:length(mse_ph_fb)-1),'Sheet1',['A2:A' num2str(length(mse_ph_fb))]);
xlswrite('mseplots_ph_sbmir.xlsx',mse_ph_fb(2:length(mse_ph_fb)),'Sheet1','B2');
xlswrite('mseplots_ph_sbmir.xlsx',mse_ph_fb3(2:length(mse_ph_fb3)),'Sheet1','C2');
% xlswrite('mseplots_ph_sbmir.xlsx',mse_ph_fb2(2:length(mse_ph_fb2)),'Sheet1','D2');

%% Display results
figure(1),
% subplot(211),imshow(mat2gray(phFB)),axis image; colormap(gray(255)); title('AS')
% subplot(212),imshow(mat2gray(phFB3)),axis image; colormap(gray(255)); title('IR')
% figure(1),
subplot 221, imshow(mat2gray(ampFB)); axis image; colormap(gray(255)); title('AMP: SBMIR');
subplot 222, imshow(mat2gray(phFB));  axis image; title('PH: SBMIR');
subplot 223, imshow(mat2gray(ampFB3));  axis image; colormap(gray(255)); title('AMP: SBMIR-F');
subplot 224, imshow(mat2gray(phFB3));  axis image; title('PH: SBMIR-F');
% 
figure(2),hold on
plot(2:length(mse_amp_fb),mse_amp_fb(2:length(mse_amp_fb)), ...
    'b','Marker','o','Linewidth',2,'LineStyle','-');
plot(2*(2:length(mse_amp_fb3)),mse_amp_fb3(2:length(mse_amp_fb3)), ...
    'r','Marker','*','LineStyle','--')
set(gca,'FontSize',28);
xlabel('Iteration','FontSize',28), ylabel('Amplitude MSE','FontSize',28), xlim([0,iter]); 
% ylim([min(mse_amp_ASC(2:length(mse_amp_ASC))),max(mse_amp_fb)])
legend('SBMIR','SBMIR-F(compensated)','Location', 'NorthEast','Orientation','vertical'); 
% % saveas(gcf, [root_to,'\AMSEplot_iter=',num2str(iter),'_num=',num2str(num),'.png']); %save figure

figure(3),hold on
plot(2:length(mse_ph_fb),mse_ph_fb(2:length(mse_ph_fb)), ...
    'b','Marker','o','Linewidth',2,'LineStyle','-');
plot(2*(2:length(mse_ph_fb3)),mse_ph_fb3(2:length(mse_ph_fb3)), ...
    'r','Marker','*','LineStyle','--')
set(gca,'FontSize',28);
xlabel('Iteration','FontSize',28), ylabel('Phase MSE','FontSize',28), xlim([0,iter]); 
% ylim([min(mse_ph_ASC(2:length(mse_ph_ASC))),max(mse_ph_ASC)])
legend('SBMIR','SBMIR-F(compensated)','Location', 'NorthEast','Orientation','vertical'); 
% clear all; close all;

%% display iterations 10, 50, and 170
resultroot=[root 'FRCV-results\'];

imgarray=zeros([600,600,6]); %Empty array

AS1='AS\PhFB_num=5_iter=10.bmp';
AS2='AS\PhFB_num=5_iter=50.bmp';
AS3='AS\PhFB_num=5_iter=170.bmp';
% TF1='TF\PhFB_num=5_iter=10.bmp';
% TF2='TF\PhFB_num=5_iter=50.bmp';
% TF3='TF\PhFB_num=5_iter=170.bmp';
IR1='IR\PhFB_num=5_iter=10.bmp';
IR2='IR\PhFB_num=5_iter=50.bmp';
IR3='IR\PhFB_num=5_iter=170.bmp';
imgarray(:,:,1)=double(imread([resultroot AS1]));
imgarray(:,:,2)=double(imread([resultroot AS2]));
imgarray(:,:,3)=double(imread([resultroot AS3]));
% imgarray(:,:,4)=double(imread([resultroot TF1]));
% imgarray(:,:,5)=double(imread([resultroot TF2]));
% imgarray(:,:,6)=double(imread([resultroot TF3]));
imgarray(:,:,4)=double(imread([resultroot IR1]));
imgarray(:,:,5)=double(imread([resultroot IR2]));
imgarray(:,:,6)=double(imread([resultroot IR3]));

rawr=[170,10,50];
figure(4)
for i=1:6
    subplot(2,3,i), imagesc(imgarray(:,:,i)), axis image; axis off; colormap(gray(255));
    if i<4
        title(['AS iter' num2str(rawr(mod(i,3)+1))])
    end
    if i>3
        title(['IR iter' num2str(rawr(mod(i,3)+1))])
    end
end