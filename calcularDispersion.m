
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



%% Ajuste de la curva cuadr�tica
coeficientes = polyfit(u, D3, 2);
curva_cuadratica = polyval(coeficientes, u);

%% Graficar curva de dispersion
figure(5); clf; 
hold on
plot(u, D3,'o')
% Curva cuadr�tica ajustada
plot(u, curva_cuadratica, 'r-', 'DisplayName', 'Curva cuadr�tica ajustada');
xlabel('Numero de modo (\mu)')
ylabel('(\omega_{\mu} - \omega_{0} - D1\mu)/2\pi (GHz)')
title('Curva de dispersion anillo microresonador de 100 [um]')
legend('show');