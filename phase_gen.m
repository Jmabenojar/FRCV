function ph = phase_gen(M,cp,lambda,shape,varargin)
%This function generates a simulation of an optical phase
%M - array size (assumes a square matrix)
%cp - pixel pitch
%shape - shape of the optical phase
%lambda - wavelength
L = cp*M;  %side length
x=-L/2:cp:L/2-cp; %spatial coords
[X,Y]=meshgrid(x,x);
k = 2*pi/lambda;

switch shape
    case 'spherical'
        f = varargin{:}; %focal length
        ph = -k/(2*f).*(X.^2+Y.^2);
    case 'cylindrical'
        f = varargin{:}; %focal length
        ph = -k/(2*f).*(X+Y).^2;
    case 'tilted'
        fr_d = varargin{:};
        ph = -k*fr_d.*(X+Y);
    case 'constant'
        ph = ones(M,M);
    otherwise
        error('Unknown phase shape');
end