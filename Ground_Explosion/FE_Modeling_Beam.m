function FE_Modeling_Beam(L,at,ASTM,EL,folderName)

L = L*12; %ft to inch
if ASTM ==5
    RD = 0.625;
elseif ASTM ==8
    RD = 1;
elseif ASTM ==11
    RD = 1.410;
else
    disp("Error:Check Rebar Diameter ")
end

% 길이 방향의 Rebar의 갯수
RebarNumber_X = floor(L/(at)/2);
RebarNumber_Y = floor(L/(at));
%NodeNumber per directoin
NN_X = round(L/EL/2)+1;
NN_Y = round(L/EL)+1;
% Element Number per dirction
EN_X = (NN_X-1)*RebarNumber_Y;
EN_Y = (NN_Y-1)*RebarNumber_X;
%node node(node number, x coord., y coord.) 
node = zeros(EN_X+EN_Y+1,4);
set_node_xsym = zeros(RebarNumber_X,1);
% set_node_ysym = zeros(RebarNumber_Y,1);
%node 위치 계산
xsym = 1;
% ysym = 1;


for i = 1:RebarNumber_Y
    for j = 1:NN_X
        n = NN_X*(i-1)+(j-1)+1; %n=node number
        node(n,:,:,:) = [n,EL*(j-1),at*(i-1)+at/2,0]; %node(node number, x coord., y coord.,z coord.) 
            if j == 1
                set_node_xsym(xsym) = n;
                xsym = xsym+1;
            end
    end
end
m=n;
for i = 1:RebarNumber_X
    for j = 1:NN_Y
        m = n+NN_Y*(i-1)+(j-1)+1; %n=node number
        %node(m,:,:,:) = [m,at*(i-1)+at/2,EL*(j-1),RD]; %node(node number, x coord., y coord. ,z coord.)
        node(m,:,:,:) = [m,at*(i-1)+at/2,EL*(j-1),0]; %node(node number, x coord., y coord. ,z coord.)
            %if j == 1
                %set_node_ysym(ysym) = m;
                % ysym = ysym+1;
            %end
    end
end

%element 
element_beam = zeros(EN_X+EN_Y,4);
for i = 1:RebarNumber_Y
    for j=1:NN_X-1
        mx = (NN_X-1)*(i-1)+(j-1)+1;
        n1 = (NN_X)*(i-1)+(j-1)+1;
        n2 = n1+1;
        element_beam(mx,:,:,:) = [mx,1,n1,n2];
    end
end

for i = 1:RebarNumber_X
    for j=1:NN_Y-1
        my = (NN_Y-1)*(i-1)+(j-1)+1+mx;
        n1 = (NN_Y)*(i-1)+(j-1)+1+n;
        n2 = n1+1;
        element_beam(my,:,:,:) = [my,1,n1,n2];
    end
end

    newPath = folderName;

    filePath = fullfile(newPath, 'gen_beam.k'); % 파일 경로 설정
    fileID = fopen(filePath, 'w');
    fprintf(fileID ,'*KEYWORD\n'); % k 파일 시작
    fprintf(fileID ,'*NODE\n');
    for i = 1 : m
    fprintf(fileID,'%8d %15d %15d %15d %8d %8d \n',node(i,1),node(i,2),node(i,3),node(i,4),'','');
    end
    fprintf(fileID ,'*ELEMENT_BEAM\n');
    for i = 1 : my
    fprintf(fileID,'%8d %7d %7d %7d %7d %7d %7d %7d %7d %7d\n',element_beam(i,1),element_beam(i,2),element_beam(i,3),element_beam(i,4),'','','','','','');
    end
    
    %set_node : X_SYM 경계조건을 적용할 노드 set
    fprintf(fileID ,'*SET_NODE_LIST\n');
    %S DA1 DA2 DA3 DA4 Solver ITS -
    fprintf(fileID,'%10d %9d %9d %9d %9d %9s %9d %9d\n',12,0,0,0,0,"MECH",1,0);
    %nid1 nid2 nid3 nid4 nid5 nid6 nid7 nid8
    fprintf(fileID,'%10d %9d %9d %9d %9d %9d %9d %9d\n',set_node_xsym);
    fprintf(fileID,'\n');
    %경계조건
    fprintf(fileID ,'*BOUNDARY_SPC_SET\n');    
    %nsid1 cid2 dofx dofy dofz dofrx dofty dofrz
    fprintf(fileID,'%10d %9d %9d %9d %9d %9d %9d %9d\n',12,0,1,0,0,0,1,1);
    
    %set_node : Y_SYM 경계조건을 적용할 노드 set
    %{
    fprintf(fileID ,'*SET_NODE_LIST\n');
    %S DA1 DA2 DA3 DA4 Solver ITS -
    fprintf(fileID,'%10d %9d %9d %9d %9d %9s %9d %9d\n',13,0,0,0,0,"MECH",1,0);
    %nid1 nid2 nid3 nid4 nid5 nid6 nid7 nid8
    fprintf(fileID,'%10d %9d %9d %9d %9d %9d %9d %9d\n',set_node_ysym);
    fprintf(fileID,'\n');
    %경계조건
    fprintf(fileID ,'*BOUNDARY_SPC_SET\n');    
    %nsid1 cid2 dofx dofy dofz dofrx dofty dofrz
    fprintf(fileID,'%10d %9d %9d %9d %9d %9d %9d %9d\n',13,0,0,1,0,1,0,1);
    %}



    fprintf(fileID,'*END'); % k 파일 종료    
    
    % 파일 닫기
    fclose(fileID);

end