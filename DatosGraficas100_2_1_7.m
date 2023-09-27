clc;
clear all
format shortG
%% calcular FSR teorico del anillo

c= 2.99792458e8;               %velocidad de la luz m/s
r= 100e-6;                      %radio del anillo en micrometros
mrL = 2*pi*r ;                 %longitud del anillo
mrFsr = c/(2.11*mrL)/1e9;      %Rango espectral libre teorico y lo almacene en Gigahertz  1e9
disp('Valor de FSR teorico en Gigahertz:')
disp(mrFsr)
%%1.9963 

%% Base de datos tomada del anillo resonador para 100 um
filename1 = '100_1500_1600_1.7.txt';
% filename2 = '100_1520_1540_2.txt';
% filename3 = '100_1540_1560_2.txt';
% filename4 = '100_1560_1580_2.txt';
% filename5 = '100_1580_1600_2.txt';

% Importar los datos
[A1, delimiterOut1] = importdata(filename1);
% [A2, delimiterOut2] = importdata(filename2);
% [A3, delimiterOut3] = importdata(filename3);
% [A4, delimiterOut4] = importdata(filename4);
% [A5, delimiterOut5] = importdata(filename5);

% Extraer los datos de longitud de onda y transmitancia
wavelength1 = A1(:, 1);
transmitance1 = A1(:, 2);

% wavelength2 = A2(:, 1);
% transmitance2 = A2(:, 2);
% 
% wavelength3 = A3(:, 1);
% transmitance3 = A3(:, 2);
% 
% wavelength4 = A4(:, 1);
% transmitance4 = A4(:, 2);
% 
% wavelength5 = A5(:, 1);
% transmitance5 = A5(:, 2);

% Convertir los valores de longitud de onda a nanómetros
wavelength1 = wavelength1 * 1000;
% wavelength2 = wavelength2 * 1000;
% wavelength3 = wavelength3 * 1000;
% wavelength4 = wavelength4 * 1000;
% wavelength5 = wavelength5 * 1000;

% Graficar los datos
figure(1)

% Juntar los datos en una sola matriz
wavelength = [wavelength1];
transmitance = [transmitance1];



% Graficar los datos juntos
plot(wavelength, transmitance, 'LineWidth', 1.5)

% Etiquetas y título del gráfico
xlabel('Longitud de onda [nm]')
ylabel('Transmitancia')
title('Gráfico de datos anillo microresonador de 100 [um]')


%% obtener las longitudes de onda/frecuencias minimas de cada pico

% Encontrar los mínimos (picos)
[peaks, peakIndices] = findpeaks(-transmitance);

% Filtrar los mínimos por debajo de 0.5 en transmitancia
filteredPeakIndices = peakIndices(transmitance(peakIndices) < 0.93);
filteredPeaks = peaks(transmitance(peakIndices) < 0.93);

% Almacenar los valores de longitud de onda y transmitancia correspondientes a los mínimos filtrados
minWavelengths = wavelength(filteredPeakIndices);
minTransmitance = transmitance(filteredPeakIndices);

% minWavelengths(62) = []; % Eliminar la posición por índice
% minTransmitance(62) = []; % Eliminar la posición por índice

% Mostrar los valores de los mínimos filtrados
disp('Valores de los mínimos filtrados:')
disp([minWavelengths, minTransmitance])

% Graficar los datos de las frecuencias minimas vs la transmitacia
figure(2)
plot(minWavelengths, minTransmitance, "o")
% Etiquetas y título del gráfico
xlabel('Longitud de onda [nm]')
ylabel('Transmitancia')
title('Gráfico de datos anillo microresonador de 100 [um]')

%% convertir longitudes de onda minimas encontradas a frecuencias

frecuencias_GHz = c./ minWavelengths;
frecuencias_GHz_2 = flipud(frecuencias_GHz); %invertir el vector para despues manipularlo en las graficas

% Graficar los datos de las frecuencias minimas 
figure(3)
plot(frecuencias_GHz,minTransmitance, "*")
% Etiquetas y título del gráfico
xlabel('Frencuencia [GHz]')
ylabel('Transmitancia')
title('Gráfico de datos anillo microresonador de 100 [um]')

% Mostrar los valores de las frecuencias en gigahertz ajustadas
disp('Valores de las frecuencias en gigahertz:')
disp(frecuencias_GHz_2)


%% Ecuacion para el calculo curva de dispersion D3
% si el vector de Frecuencias es par
if mod(length(frecuencias_GHz_2), 2) == 0
    frecuencias_GHz_2=frecuencias_GHz_2(2:end); 
    posicion_central = (length(frecuencias_GHz_2) / 2)-.5;
    f0= frecuencias_GHz_2(posicion_central); %calcular la  frecuencia central de los picos de resonancia
    u = ((-length((frecuencias_GHz_2))/ 2)+.5:length(frecuencias_GHz_2)/ 2-.5)';
    mrFsr_2=( frecuencias_GHz_2(posicion_central)-frecuencias_GHz_2(posicion_central-1) + frecuencias_GHz_2(posicion_central+1)-frecuencias_GHz_2(posicion_central))/2 ; % FRS de los datos obtenidos
    D1 = mrFsr_2.*u;
    D3 = frecuencias_GHz_2 - f0 - D1;
% si el vector de Frecuencias es impar    
else
 
    posicion_central = (length(frecuencias_GHz_2) / 2)-.5;
    f0= frecuencias_GHz_2(posicion_central); %calcular la  frecuencia central de los picos de resonancia
    u = ((-length((frecuencias_GHz_2))/ 2)+.5:length(frecuencias_GHz_2)/ 2-.5)';
    mrFsr_2=( frecuencias_GHz_2(posicion_central)-frecuencias_GHz_2(posicion_central-1) + frecuencias_GHz_2(posicion_central+1)-frecuencias_GHz_2(posicion_central))/2 ; % FRS de los datos obtenidos
    D1 = mrFsr_2.*u;
    D3 = frecuencias_GHz_2 - f0 - D1;
end



%% Ajuste de la curva cuadrática
coeficientes = polyfit(u, D3, 2);
curva_cuadratica = polyval(coeficientes, u);

%% Graficar curva de dispersion
figure(5); clf; 
hold on
plot(u, D3,'o')
% Curva cuadrática ajustada
plot(u, curva_cuadratica, 'r-', 'DisplayName', 'Curva cuadrática ajustada');
xlabel('Numero de modo (\mu)')
ylabel('(\omega_{\mu} - \omega_{0} - D1\mu)/2\pi (GHz)')
title('Curva de dispersion anillo microresonador de 100 [um]')
legend('show');
