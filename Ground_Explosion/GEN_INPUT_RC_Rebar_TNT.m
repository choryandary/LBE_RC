clear all
close all

%% Input

% [kg],[mm],[ms],[GPa]
%Modeling input

%%%%%%%%%%%%%%%%%%%%%
% Control Parameter %
%%%%%%%%%%%%%%%%%%%%%
Z = [0.4]; % [m*kg^(-1/3)] % change parameter (interval 0.05)
CD = 2;%Coverdepth %[in]

% SungBo

% Concrete Parameter
L = [20]; %Length [ft]
Dt = [6 12 18]; %Dt = [6 12 18 24 36 48] ;% Depth [in] 6in 1ft 1ft6in, 2ft, 3ft, 4ft
S = [3]; %Slab 1-way, 2-way
Fs = [4]; %Fs = [40 50]; % [ksi]  %*6.829476e-6 %GPa, 40000 psi, 50000psi
%rebar 
at = [9 12 15]; %space [in] % at = [9 12 15] %space [in]
ASTM = [5 8 11] ; %ASTM = [5 8 11] ;
RD = [0.625 1 1.410] ;%RD = [0.625 1 1.410]; % Diameter [in](괄호안은 인치) ASTM #5 #8 #11 
CD = 2;%Coverdepth %[in]
%TNT 
W = [900]; %TNT Weight [kg]
%R = W.^(1/3).*Z %stand off distance [m]


% JaeHyun

%{
% Concrete Parameter
L = [20]; %Length [ft]
Dt = [24 36 48]; %Dt = [6 12 18 24 36 48] ;% Depth [in] 6in 1ft 1ft6in, 2ft, 3ft, 4ft
S = [3]; %Slab 1-way, 2-way
Fs = [4]; %Fs = [40 50]; % [ksi]  %*6.829476e-6 %GPa, 40000 psi, 50000psi
%rebar 
at = [9 12 15]; %space [in] % at = [9 12 15] %space [in]
ASTM = [5 8 11] ; %ASTM = [5 8 11] ;
RD = [0.625 1 1.410] ;%RD = [0.625 1 1.410]; % Diameter [in](괄호안은 인치) ASTM #5 #8 #11 
%TNT 
W = [900]; %TNT Weight [kg]
%R = W.^(1/3).*Z %stand off distance [m]
%}





%FEM input
EL = 0.75; % Element Length [in]
%% DBpath 

% Naming Folder name
mkdir F:\Ground_Explosion
newPath = 'F:\Ground_Explosion'; % 원하는 새 경로로 변경하세요
cd(newPath);
%Gen_batch
filePath = fullfile(newPath,'run.bat');
batchfile = fopen(filePath, 'w');
i=1;
for l = 1:length(L)
    for dt = 1:length(Dt)
        for s=1:length(S)
            for f=1:length(Fs)
                for a = 1: length(at)
                    for r = 1: length(ASTM)
                        for w = 1: length(W)
                            for z = 1 : length(Z)


%FEM input
%EL = L(l)/25; % Element Length [in]
    folderName = strcat('L',int2str(L(l)),'_Dt',int2str(Dt(dt)),'_Fs', string(Fs(f)), ...
        '_at', int2str(at(a)), '_ASTM', int2str(ASTM(r)),'_W',int2str(W(w)),'_Z',string(Z(z)));
    mkdir(folderName); % 폴더 생성

%% Concrete modeling
FE_Modeling_Solid(L(l),Dt(dt),S(s),Fs(f),EL,folderName)
%FE_Modeling_Solid(L(l),Dt(dt),Fs(f),EL,folderName)
FE_Modeling_Beam(L(l),at(a),ASTM(r),EL,folderName)
%FE_Modeling_Rigid(L(l),Dt(dt),S(s),Fs(f),EL,folderName)
FE_RC_Converting(Dt(dt),ASTM(r),CD,folderName)
LBE_SET(Fs(f),W(w),Z(z),Dt(dt),ASTM(r),folderName)
GEN_Batch(batchfile,newPath,folderName)
totalcase = length(L)*length(Dt)*length(S)*length(Fs)*length(at)*length(ASTM)*length(W)*length(Z);
progress = ['Progress : ',num2str(i),'/',num2str(totalcase)];
disp(progress);
i=i+1;
                            end
                        end
                    end
                end
            end
        end
    end
end

fclose(batchfile);
%system('F:\DBdir\run.bat','-echo')