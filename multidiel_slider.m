% multidiel_slider.m - GUI slider attempts in reflectance simulations

% L vs reflectance ciz
% Lambda slider koy
% Red green blue spectrumlar ne 
% Spectrum convolve with 'Reflection vs L

%lambda vs Reflectance graph slider with L
%RGB spectrum
%convolve with Reflection vs lambda graph

%once sliderlar
%sonra RGB(L) 
graph = plot(L,Gamma)
xlabel('L (\mum)');
ylabel('Reflectance (%)');

b = uicontrol('Parent',graph,'Style','slider','value',lambda, 'min',0.4, 'max',0.68);

bgcolor = f.Color;
bl1 = uicontrol('Parent',f,'Style','text','Position',[50,54,23,23],...
                'String','0','BackgroundColor',bgcolor);
bl2 = uicontrol('Parent',f,'Style','text','Position',[500,54,23,23],...
                'String','1','BackgroundColor',bgcolor);
bl3 = uicontrol('Parent',f,'Style','text','Position',[240,25,100,23],...
                'String','Damping Ratio','BackgroundColor',bgcolor);

b.Callback = @(es,ed) updateSystem(graph,tf(L,[1,2*(es.Value)*L,L^2])); 