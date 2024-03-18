function obj = obj_gen(dx,M,wd,Shape)
%This function generates a simple shape and assumes uniform sampling
%dx - pixel pitch
%M - ccd sampling size
%wd - diameter (if circle) or half-width (if square) in m
%Shape - shape to generate: circle or square
L = M*dx;
x1 = -L/2:dx:L/2-dx; %src coordinates
y1 = x1;
[X1,Y1]=meshgrid(x1,y1);
P = 1e-4;
switch upper(Shape)
    case 'CIRCLE'
        u1 = circ(sqrt(X1.^2+Y1.^2)/(wd/2)); %src field
        obj = abs(u1.^2); %src irradiance
    case 'SQUARE'
        u1 = rect(X1/(2*wd)).*rect(Y1/(2*wd));
        obj = abs(u1.^2);
    case 'SGRT'
        u1 = rect(X1/P).*(1/P).*ucomb(X1/P).*rect(X1/wd).*rect(Y1/wd);
        obj = abs(u1.^2);
    otherwise
        error('Unknown shape %s',upper(Shape))
end
end