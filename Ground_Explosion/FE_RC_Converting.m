function FE_RC_Converting(Dt,ASTM,CD,folderName)

    newPath = folderName;

if ASTM ==5
    RD = 0.625;
elseif ASTM ==8
    RD = 1;
elseif ASTM ==11
    RD = 1.410;
else
    disp("Error:Check Rebar Diameter ")
end

    filePath = fullfile(newPath, 'FE_Model_RC_mm.k'); % 파일 경로 설정
    fileID = fopen(filePath, 'w');
    fprintf(fileID ,'*KEYWORD\n'); % k 파일 시작

    % Include rebar model 1, cover depth, scale in to mm
    fprintf(fileID ,'*DEFINE_TRANSFORMATION \n');
    fprintf(fileID,'%9d \n',1);
    fprintf(fileID,'%9s %9.7g %9.7g %9.7g %9.7g %9.7g %9.7g %9.7g\n','TRANSL',0,0,CD,0,0,0,0);
    fprintf(fileID,'%9s %9.7g %9.7g %9.7g %9.7g %9.7g %9.7g %9.7g\n','SCALE',25.4,25.4,25.4,0,0,0,0);

    % Include rebar model 2, cover depth, scale in to mm
    fprintf(fileID ,'*DEFINE_TRANSFORMATION \n');
    fprintf(fileID,'%9d \n',2);
    %fprintf(fileID,'%9s %9.7g %9.7g %9.7g %9.7g %9.7g %9.7g %9.7g\n','TRANSL',0,0,Dt-CD-RD,0,0,0,0);
    fprintf(fileID,'%9s %9.7g %9.7g %9.7g %9.7g %9.7g %9.7g %9.7g\n','TRANSL',0,0,Dt-CD,0,0,0,0);
    fprintf(fileID,'%9s %9.7g %9.7g %9.7g %9.7g %9.7g %9.7g %9.7g\n','SCALE',25.4,25.4,25.4,0,0,0,0);

    % Include Concrete model, scale in to mm
    fprintf(fileID ,'*DEFINE_TRANSFORMATION \n');
    fprintf(fileID,'%9d \n',3);
    fprintf(fileID,'%9s %9.7g %9.7g %9.7g %9.7g %9.7g %9.7g %9.7g\n','SCALE',25.4,25.4,25.4,0,0,0,0);

    % Include rebar model 1
    fprintf(fileID ,'*INCLUDE_TRANSFORM\n');
    fprintf(fileID ,'gen_beam.k \n');
    fprintf(fileID,'%9d %9d %9d %9d %9d %9d %9d\n',1e6,1e6,1e6,10,10,0,0);
    fprintf(fileID,'%9d %9d %9d %9d \n',0,0,0,0);
    fprintf(fileID,'%9d %9d %9d %9d %9d %9d \n',0,0,0,0,0,0);
    fprintf(fileID,'%9d \n',1);

    % Include rebar model 2
    fprintf(fileID ,'*INCLUDE_TRANSFORM\n');
    fprintf(fileID ,'gen_beam.k \n');
    fprintf(fileID,'%9d %9d %9d %9d %9d %9d %9d\n',2e6,2e6,2e6,20,20,0,0);
    fprintf(fileID,'%9d %9d %9d %9d \n',0,0,0,0);
    fprintf(fileID,'%9d %9d %9d %9d %9d %9d \n',0,0,0,0,0,0);
    fprintf(fileID,'%9d \n',2);
    
    % Include Concrete model
    fprintf(fileID ,'*INCLUDE_TRANSFORM\n'); 
    fprintf(fileID ,'gen_solid.k \n');
    fprintf(fileID,'%9d %9d %9d %9d %9d %9d %9d\n',1e7,1e7,1e7,0,0,0,0);
    fprintf(fileID,'%9d %9d %9d %9d \n',0,0,0,0);
    fprintf(fileID,'%9d %9d %9d %9d %9d %9d \n',0,0,0,0,0,0);
    fprintf(fileID,'%9d \n',3);

    fprintf(fileID,'*END'); % k 파일 종료    


end