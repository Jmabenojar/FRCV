function an = swrap(u_in,method,varargin)
%u_in - input wave field
%an - output mask
root_to = 'C:\Users\Admin\OneDrive - University of the Philippines\MATLAB\THESIS IMAGE DUMP\April 30 2019';
switch  method
    case 'adaptive'
        r = varargin{1}; %radius of the frequency low-pass filter
        th = varargin{2}; %gray level threshold
        uf = lowpassf(u_in,r); %low-pass filter the input
%         imwrite(uint8(normalize(crp(abs(uf).^2,[800/2 800/2],650))),[root_to,'filtfield.bmp']);
        an = im2bw(abs(uf).^2,th); %generate the mask by thresholding
    case 'fixed'
        rt = varargin{1}; %radius of the mask
        xc = varargin{2}; %x-center of the mask
        yc = varargin{3}; %y-center of the mask
        [M,N] = size(u_in);
        x1 = -M/2:M/2-1; %pixel coordinates
        y1 = x1;
        [X1,Y1] = meshgrid(x1,y1);
        an = (X1-xc).^2+(Y1-yc).^2 <= rt.^2; %generate mask (circular)
    otherwise
        error('Unknown support determination method');
end