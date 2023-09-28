function LBE_SET(Fs,W,Z,Dt,ASTM,folderName)

    %parameters
    W = W;                      %[kg]
    R_m = Z*W^(1/3);            %[m]
    R_mm = R_m*1000+Dt*25.4;    %[mm] 콘크리트 두께+이격거리
    Fs = Fs*0.006895;           %[GPa], kPsi to GPa
    if ASTM ==5
        RD = 0.625*25.4;
    elseif ASTM ==8
        RD = 1*25.4;
    elseif ASTM ==11
        RD = 1.410*25.4;
    else
        disp("Error:Check Rebar Diameter ")
    end



    filePath = fullfile(folderName, 'LBE_Set.k'); % 파일 경로 설정
    % 텍스트 파일 열기
    fileID = fopen(filePath, 'w');
    fprintf(fileID ,'*KEYWORD\n'); % k 파일 시작

    fprintf(fileID ,'*TITLE\n'); % k 파일 시작
    fprintf(fileID ,'Blast pressure(unit : kg, mm, msec, N, GPa)\n'); 

    % LBE 설정 W : TNT 중량(kg), R : 이격거리(mm)
    fprintf(fileID ,'$===============================================================================\n'); 
    fprintf(fileID ,'$Define Vector\n'); 
    fprintf(fileID ,'$===============================================================================\n');
    fprintf(fileID ,'*DEFINE_VECTOR\n');
    fprintf(fileID,'%9d %9.7g %9d %9d %9.7g %9d %9d %9d\n',1,0,0,0,0,1,0,0);
    fprintf(fileID ,'*NODE\n');
    fprintf(fileID,'%8d %15d %15d %15d %8d %8d \n',1,0,0,0,'','');

    % LBE 설정 W : TNT 중량(kg), R : 이격거리(mm)
    fprintf(fileID ,'$===============================================================================\n'); 
    fprintf(fileID ,'$Load card\n'); 
    fprintf(fileID ,'$===============================================================================\n');
    fprintf(fileID ,'*LOAD_BLAST_ENHANCED\n');
    fprintf(fileID,'%9d %9.7g %9d %9d %9.7g %9d %9d %9d\n',1,W,0,1000,R_mm,0,6,4);
    fprintf(fileID,'%9d %9d %9d %9d %9d %9d %9d\n',0,0,0,0,0,0,0);
    fprintf(fileID,'%9d %9d \n',1,1);
    fprintf(fileID ,'*LOAD_BLAST_SEGMENT_SET\n');
    fprintf(fileID,'%9d %9d %9d %9d %9d \n',1,1,0,0,0);


    %Conctol Card
    fprintf(fileID ,'$===============================================================================\n'); 
    fprintf(fileID ,'$Control Card\n'); 
    fprintf(fileID ,'$===============================================================================\n'); 
    fprintf(fileID ,'*CONTROL_TERMINATION\n'); 
    fprintf(fileID ,'100.0\n'); 
    fprintf(fileID ,'*CONTROL_TIMESTEP\n'); 
    fprintf(fileID ,'0,0.1,0,0,0,0,0\n'); 
    fprintf(fileID ,'0,0,0,0,0,0\n'); 
    fprintf(fileID ,'*CONTROL_ACCURACY\n'); 
    fprintf(fileID ,'1,4,0,0\n'); 
    fprintf(fileID ,'*CONTROL_ENERGY\n'); 
    fprintf(fileID ,'2,2,2,1\n'); 
    fprintf(fileID ,'*CONTROL_OUTPUT\n'); 
    fprintf(fileID ,'0,0,0,0,0,0\n'); 
    fprintf(fileID ,'0,0,2,50,0,0,0\n')

    %Constrained Card
    fprintf(fileID ,'$===============================================================================\n'); 
    fprintf(fileID ,'$Constrained Card\n'); 
    fprintf(fileID ,'$===============================================================================\n'); 
    fprintf(fileID ,'*CONSTRAINED_BEAM_IN_SOLID_PENALTY_ID\n'); 
    fprintf(fileID ,'1\n'); 
    fprintf(fileID ,'1000001,10000001,1,1,\n'); 
    fprintf(fileID ,'\n'); 
    fprintf(fileID ,'*CONSTRAINED_BEAM_IN_SOLID_PENALTY_ID\n'); 
    fprintf(fileID ,'2\n'); 
    fprintf(fileID ,'2000001,10000001,1,1,\n'); 
    fprintf(fileID ,'\n'); 

    %Database card
    fprintf(fileID ,'$===============================================================================\n'); 
    fprintf(fileID ,'$Database card\n'); 
    fprintf(fileID ,'$===============================================================================\n'); 
    fprintf(fileID ,'*DATABASE_BINARY_D3PLOT\n'); 
    fprintf(fileID,'%10.6g %9d %9d %9d %9d\n',0,0,0,100,0); 
    fprintf(fileID,'%10d \n',0); 
    fprintf(fileID ,'*DATABASE_BINARY_BLSTFOR\n'); 
    fprintf(fileID,'%10.6g %9d %9d %9d %9d\n',0.1,0,0,0,0); 
    fprintf(fileID ,'*DATABASE_GLSTAT\n');
    fprintf(fileID,'%10.6g %9d %9d %9d \n',0.1,3,0,1); 
    fprintf(fileID ,'*DATABASE_MATSUM\n');
    fprintf(fileID,'%10.6g %9d %9d %9d \n',0.1,3,0,1); 
    %Part Card
    fprintf(fileID ,'$===============================================================================\n'); 
    fprintf(fileID ,'$Part Card\n'); 
    fprintf(fileID ,'$===============================================================================\n');
    fprintf(fileID ,'*PART\n'); %Part card
    fprintf(fileID ,'Rebar_1\n'); % Part card 설명
    fprintf(fileID,'%10d %9d %9d %9d %9d %9d %9d %9d\n',1000001,1,1,0,1,0,0,0); 
    fprintf(fileID ,'*PART\n'); %Part card
    fprintf(fileID ,'Rebar_2\n'); % Part card 설명
    fprintf(fileID,'%10d %9d %9d %9d %9d %9d %9d %9d\n',2000001,1,1,0,1,0,0,0); 
    fprintf(fileID ,'*PART\n'); %Part card
    fprintf(fileID ,'Concrete\n'); % Part card 설명
    fprintf(fileID,'%10d %9d %9d %9d %9d %9d %9d %9d\n',10000001,2,2,0,1,0,0,0); 



    fprintf(fileID ,'$===============================================================================\n'); 
    fprintf(fileID ,'$Hourglass Card\n'); 
    fprintf(fileID ,'$===============================================================================\n');
    fprintf(fileID ,'*HOURGLASS_TITLE\n');
    fprintf(fileID ,'hourglass\n')
    fprintf(fileID,'%10d %9d %9.7g \n',1,3, 0.1); 

    fprintf(fileID ,'$===============================================================================\n'); 
    fprintf(fileID ,'$Section Card\n'); 
    fprintf(fileID ,'$===============================================================================\n');
    fprintf(fileID ,'*SECTION_BEAM_TITLE\n'); %Part card
    fprintf(fileID ,'Rebar\n'); % 
    fprintf(fileID,'%10d %9d %9d %9d %9d %9d %9d %9d\n',1,1,1,0 ,1 ,0,0,0 ); 
    fprintf(fileID,'%10.7g %9.7g %9.7g %9.7g %9d %9d %9d %9d\n',RD,RD,0,0,0,0,0,0); 
    fprintf(fileID ,'*SECTION_SOLID\n'); 
    fprintf(fileID,'%10d %9d %9d %9d %9d %9d %9d %9d\n',2,1,0,0 ,0 ,0,0,0 );

    fprintf(fileID ,'$===============================================================================\n'); 
    fprintf(fileID ,'$Material Card\n'); 
    fprintf(fileID ,'$===============================================================================\n');
    fprintf(fileID ,'*MAT_PIECEWISE_LINEAR_PLASTICITY_TITLE\n'); %Part card
    fprintf(fileID ,'steel\n'); % Part card 설명
    fprintf(fileID,'%10d %9.7g %9.7g %9.7g %.7g %9d %9.7g %9d\n',1,7.85000E-6,207,0.3,0.4137,'',0.3,'');
    fprintf(fileID,'%10.7g %9.7g %9.7g %9.7g %9d\n',40000,5,'','',-1);
    fprintf(fileID,'\n');
    fprintf(fileID,'\n');
    fprintf(fileID ,'*MAT_CSCM_CONCRETE_TITLE\n'); %Part card
    fprintf(fileID ,'Concrete\n'); % Part card 설명
    fprintf(fileID,'%10d %9.7g %9d %9.7g %9d %9.7g %9d %9d\n',2,2.40000E-6,0,0,'',1.00,0,0 );
    fprintf(fileID,'%10.7g \n',0);
    fprintf(fileID,'%10.7g %9d %9d\n', Fs, '',0);
    
    %Include
    fprintf(fileID ,'$===============================================================================\n'); 
    fprintf(fileID ,'$include card\n'); 
    fprintf(fileID ,'$===============================================================================\n');
    fprintf(fileID ,'*INCLUDE\n');
    fprintf(fileID ,'FE_Model_RC_mm.k \n');
    fprintf(fileID,'*END'); % k 파일 종료    

        % 파일 닫기
    fclose(fileID);
end