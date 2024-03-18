close all; clear all; clc;

lambda = 632.8e-9; %wavelength
cp = 5.2e-6;          %pixel pitch
k = 2*pi/lambda;      %wavenumber             
z0 = 44e-3;             %distance between object and first plane (experimental data)
dz = 3e-3;             %distance between measurement planes (experimental)
num = 5;              %number of images
firstplane=1;
z0=z0+dz*(firstplane-1)
root='D:\Darkroom\Joshua\mainlatest\';
root_from = [root 'FRCV\exp_data\u'];     %file root to get images
root_to1 = [root 'FRCV-results\AS'];
root_to2 = [root 'FRCV-results\TF'];
root_to3 = [root 'FRCV-results\IR']; % Proposed method
ftype = '.bmp';       %file type

%% Read intensities
centr = [550 670]; %locate cropping center (experimental data)
% centr = [512 512]; % (simulated data)
arrysize = 800; %desired cropped array size 

uu = zeros(2*floor(arrysize/2),2*floor(arrysize/2),num); %create an empty array to save intensities

for ii = 1:num
   int = (imread([root_from int2str(firstplane+ii-1) ftype])); 
   int = (double(int)); %convert to double precision
%    uu(:,:,ii) = int; %%uncomment if cropping is unnecessary
   uu(:,:,ii) = crp(int,centr,arrysize); %comment if cropping is unnecessary
%    figure(101); imagesc(uu(:,:,ii)); colormap(gray(255)); axis image;
end
amps = sqrt(uu); %calculate the amplitude



%% Comparison of conventional SBMIR and SBMIR-ASC
%smoothing function
smth = @(ph,n) atan2(conv2(sin(ph),ones(n)/2,'same'),conv2(cos(ph),ones(n)/2,'same'));

iter = 170; %set the number of iterations

% phase = angle(exp(1i*randn(512,512))); %generate a guess phase from -pi to +pi
% save gph5 phase; %save the variable 'phase' with filename 'gph'
%load gph5;  %load gph

load r2; % load a guess phase (better for experimental data)
phase = padarray(phase, [arrysize/2-512/2 arrysize/2-512/2], 'both'); 
%zero pad guess phase to make it the same size as the recorded intensities

%%%SBMIR
[u_rec_sbmir,tFB,mse_amp_fb,mse_ph_fb] = sbmir(lambda,cp,dz,z0,num,iter,amps,phase,root_to1,'as'); % execute sbmir
disp(['ASM: Iterations: ',num2str(length(mse_amp_fb)-1), ...
    ' ; time: ',num2str(tFB), ' s']); %display execution time

% save mse plot to an excel file
xlswrite('mseplots_amp_sbmir.xlsx',mse_amp_fb(2:length(mse_amp_fb)), 'Sheet1','A2');
xlswrite('mseplots_ph_sbmir.xlsx',mse_ph_fb(2:length(mse_amp_fb)),'Sheet1','A2'); 

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
%% Save plots
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
subplot(211),imshow(mat2gray(phFB)),axis image; colormap(gray(255)); title('AS')
% subplot(312),imshow(phFB2),axis image; colormap(gray(255)); title('AS')
subplot(212),imshow(mat2gray(phFB3)),axis image; colormap(gray(255)); title('IR')
% figure(1),
% subplot 221, imshow(mat2gray(ampFB)); axis image; colormap(gray(255)); title('AMP: SBMIR FB');
% subplot 222, imshow(mat2gray(phFB));  axis image; title('PH: SBMIR FB');
% subplot 223, imshow(mat2gray(ampASC));  axis image; colormap(gray(255)); title('AMP: SBMIR ASC');
% subplot 224, imshow(mat2gray(phASC));  axis image; title('PH: SBMIR ASC');
% 
% figure(2),hold on
% plot(2:length(mse_amp_fb),mse_amp_fb(2:length(mse_amp_fb)), ...
%     'b','Marker','o','Linewidth',2,'LineStyle','-');
% plot(2:length(mse_amp_ASC),mse_amp_ASC(2:length(mse_amp_ASC)), ...
%     'r','Marker','*','LineStyle','--')
% set(gca,'FontSize',28);
% xlabel('Iteration','FontSize',28), ylabel('Amplitude MSE','FontSize',28), xlim([0,iter]); 
% % ylim([min(mse_amp_ASC(2:length(mse_amp_ASC))),max(mse_amp_fb)])
% legend('SBMIR','SBMIR-ASC','Location', 'NorthEast','Orientation','vertical'); 
% % % saveas(gcf, [root_to,'\AMSEplot_iter=',num2str(iter),'_num=',num2str(num),'.png']); %save figure
% 
% figure(3),hold on
% plot(2:length(mse_ph_fb),mse_ph_fb(2:length(mse_ph_fb)), ...
%     'b','Marker','o','Linewidth',2,'LineStyle','-');
% plot(2:length(mse_ph_ASC),mse_ph_ASC(2:length(mse_ph_ASC)), ...
%     'r','Marker','*','LineStyle','--')
% set(gca,'FontSize',28);
% xlabel('Iteration','FontSize',28), ylabel('Phase MSE','FontSize',28), xlim([0,iter]); 
% % ylim([min(mse_ph_ASC(2:length(mse_ph_ASC))),max(mse_ph_ASC)])
% legend('SBMIR','SBMIR-ASC','Location', 'NorthEast','Orientation','vertical'); 