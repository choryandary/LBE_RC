function FE_Modeling_Solid(L,Dt,S,Fs,EL,folderName)

% ft to inch,길이의 절반
L = L*12; 

%Number of node 
Node_Number_L = round(L/2/EL)+1; %x axis sym
Node_Number_D = round(L/EL)+1; % y
Node_Number_Dt = round(Dt/EL)+1; % z

%Number of Element
N_E_L = Node_Number_L-1; 
N_E_D = Node_Number_D-1; 
N_E_Dt = Node_Number_Dt-1;


% Initialize node, element, set_segment
node = zeros(Node_Number_L *Node_Number_D *Node_Number_Dt ,4);
element_solid = zeros((N_E_L)*(N_E_D)*(N_E_Dt),10);
set_segment_blast = zeros((N_E_L)*(N_E_D),5);

% Initialize Boundary Condition 
set_node_boundary = zeros(S*Node_Number_L,1);
set_node_xsym = zeros(Node_Number_L*Node_Number_Dt,1);
%set_node_ysym = zeros(Node_Number_L*Node_Number_Dt,1);

l = 1;
xsym = 1;

for i = 1:Node_Number_Dt %z
    for j=1:Node_Number_D %y
        for k =1:Node_Number_L %x
            % n = 
            n = Node_Number_L*Node_Number_D*(i-1)+Node_Number_L*(j-1)+(k-1)+1;
            node(n,:,:,:) = [n,EL*(k-1),EL*(j-1),EL*(i-1)];
            if S==3
                if (j == 1) || (k == Node_Number_L) % y=0 or x = L/2의 경계를 지정
                set_node_boundary(l) = n;
                l=l+1;
                end
            else 
                print "error : S is not 3"
                %{
                if ((j == Node_Number_L) )|| ((k == Node_Number_L))
                set_node_boundary(l) = n;
                l=l+1;
                end
                %}
            end
            if k == 1
                set_node_xsym(xsym) = n;
                xsym = xsym+1;
            end
        end
    end
end
s = 1;
while s<N_E_L*N_E_D
    for i = 1:N_E_Dt
        for j=1:N_E_D
            for k =1:N_E_L
                % m is element number 
                m = N_E_L*N_E_D*(i-1)+N_E_L*(j-1)+(k-1)+1;
                n1 = (k-1)+(N_E_L+1)*(j-1)+(N_E_L+1)*(N_E_D+1)*(i-1)+1;
                n2 = n1+1;
                n4 = (k-1)+(N_E_L+1)*(j)+(N_E_L+1)*(N_E_D+1)*(i-1)+1;
                n3 = n4+1;
                n5 = (k-1)+(N_E_L+1)*(j-1)+(N_E_L+1)*(N_E_D+1)*(i)+1;
                n6 = n5+1;
                n8 = (k-1)+(N_E_L+1)*(j)+(N_E_L+1)*(N_E_D+1)*(i)+1;
                n7 = n8+1;
                element_solid(m,:,:,:) = [m,1,n1,n2,n3,n4,n5,n6,n7,n8];
                if i==N_E_Dt
                set_segment_blast(s,:,:,:,:) = [s,n5, n6, n7,n8];   
                s=s+1;
                end
            end
        end
    end
end


%{
xsym = 1;
ysym = 1;
while xsym<N_E_L*N_E_Dt
    for i = 1:N_E_Dt
        for j=1:N_E_L
            for k =1:N_E_L
                if k==1
                n1 = (k-1)+(N_E_L+1)*(j-1)+(N_E_L+1)^2*(i-1)+1;
                n2 = n1+1;
                n4 = (k-1)+(N_E_L+1)*(j)+(N_E_L+1)^2*(i-1)+1;
                n3 = n4+1;
                n5 = (k-1)+(N_E_L+1)*(j-1)+(N_E_L+1)^2*(i)+1;
                n6 = n5+1;
                n8 = (k-1)+(N_E_L+1)*(j)+(N_E_L+1)^2*(i)+1;
                n7 = n8+1;
                set_segment_xsym(xsym,:,:,:,:) = [xsym,n1, n4, n5,n8];   
                xsym=xsym+1;
                end
            end
        end
    end
end
while ysym<N_E_L*N_E_Dt
    for i = 1:N_E_Dt
        for j=1:N_E_L
            for k =1:N_E_L
                if j==1
                n1 = (k-1)+(N_E_L+1)*(j-1)+(N_E_L+1)^2*(i-1)+1;
                n2 = n1+1;
                n4 = (k-1)+(N_E_L+1)*(j)+(N_E_L+1)^2*(i-1)+1;
                n3 = n4+1;
                n5 = (k-1)+(N_E_L+1)*(j-1)+(N_E_L+1)^2*(i)+1;
                n6 = n5+1;
                n8 = (k-1)+(N_E_L+1)*(j)+(N_E_L+1)^2*(i)+1;
                n7 = n8+1;
                set_segment_ysym(ysym,:,:,:,:) = [ysym,n1, n2, n5,n6];   
                ysym=ysym+1;
                end
            end
        end
    end
end
%}



    newPath = folderName;

    filePath = fullfile(newPath, 'gen_solid.k'); % 파일 경로 설정
    fileID = fopen(filePath, 'w');
    fprintf(fileID ,'*KEYWORD\n'); % k 파일 시작
    fprintf(fileID ,'*NODE\n');
    for i = 1 : n
    fprintf(fileID,'%8d %15d %15d %15d %8d %8d \n',node(i,1),node(i,2),node(i,3),node(i,4),0,0);
    end
    fprintf(fileID ,'*ELEMENT_SOLID\n');
    for i = 1 : m
    fprintf(fileID,'%8d %7d %7d %7d %7d %7d %7d %7d %7d %7d\n',element_solid(i,1),element_solid(i,2),element_solid(i,3),element_solid(i,4),element_solid(i,5),element_solid(i,6),element_solid(i,7),element_solid(i,8),element_solid(i,9),element_solid(i,10));
    end

    %set_segment_blast : load blast의 압력을 받을 segment 지정
    fprintf(fileID ,'*SET_SEGMENT\n');
    %SID DA1 DA2 DA3 DA4 Solver ITS -
    fprintf(fileID,'%10d %9d %9d %9d %9d %9s %9d %9d\n',1,0,0,0,0,"MECH",0,0);
    for i = 1: s-1
    fprintf(fileID,'%10d %9d %9d %9d %9d %9d %9d %9d\n',set_segment_blast(i,2),set_segment_blast(i,3),set_segment_blast(i,4),set_segment_blast(i,5),0,0,0,0);
    end
    %set_node : 경계조건을 적용할 노드 set
    fprintf(fileID ,'*SET_NODE_LIST\n');
    %S DA1 DA2 DA3 DA4 Solver ITS -
    fprintf(fileID,'%10d %9d %9d %9d %9d %9s %9d %9d\n',1,0,0,0,0,"MECH",1,0);
    %nid1 nid2 nid3 nid4 nid5 nid6 nid7 nid8
    fprintf(fileID,'%10d %9d %9d %9d %9d %9d %9d %9d\n',set_node_boundary);
    fprintf(fileID,'\n');
    %경계조건
    fprintf(fileID ,'*BOUNDARY_SPC_SET\n');    
    %nsid1 cid2 dofx dofy dofz dofrx dofty dofrz
    fprintf(fileID,'%10d %9d %9d %9d %9d %9d %9d %9d\n',1,0,1,1,1,1,1,1);


    %set_node : X_SYM 경계조건을 적용할 노드 set
    fprintf(fileID ,'*SET_NODE_LIST\n');
    %S DA1 DA2 DA3 DA4 Solver ITS -
    fprintf(fileID,'%10d %9d %9d %9d %9d %9s %9d %9d\n',2,0,0,0,0,"MECH",1,0);
    %nid1 nid2 nid3 nid4 nid5 nid6 nid7 nid8
    fprintf(fileID,'%10d %9d %9d %9d %9d %9d %9d %9d\n',set_node_xsym);
    fprintf(fileID,'\n');
    %경계조건
    fprintf(fileID ,'*BOUNDARY_SPC_SET\n');    
    %nsid1 cid2 dofx dofy dofz dofrx dofty dofrz
    fprintf(fileID,'%10d %9d %9d %9d %9d %9d %9d %9d\n',2,0,1,0,0,0,1,1);


    %set_node : Y_SYM 경계조건을 적용할 노드 set
    %{
    fprintf(fileID ,'*SET_NODE_LIST\n');
    %S DA1 DA2 DA3 DA4 Solver ITS -
    fprintf(fileID,'%10d %9d %9d %9d %9d %9s %9d %9d\n',3,0,0,0,0,"MECH",1,0);
    %nid1 nid2 nid3 nid4 nid5 nid6 nid7 nid8
    fprintf(fileID,'%10d %9d %9d %9d %9d %9d %9d %9d\n',set_node_ysym);
    fprintf(fileID,'\n');
    %경계조건
    fprintf(fileID ,'*BOUNDARY_SPC_SET\n');    
    %nsid1 cid2 dofx dofy dofz dofrx dofty dofrz
    fprintf(fileID,'%10d %9d %9d %9d %9d %9d %9d %9d\n',3,0,0,1,0,1,0,1);
    %}
    fprintf(fileID,'*END'); % k 파일 종료

    %{
    %set_segment_xsym : load blast의 압력을 받을 segment 지정
    fprintf(fileID ,'*SET_SEGMENT\n');
    %SID DA1 DA2 DA3 DA4 Solver ITS -
    fprintf(fileID,'%10d %9d %9d %9d %9d %9s %9d %9d\n',2,0,0,0,0,"MECH",0,0);
    for i = 1: xsym-1
    fprintf(fileID,'%10d %9d %9d %9d %9d %9d %9d %9d\n',set_segment_xsym(i,2),set_segment_xsym(i,3),set_segment_xsym(i,4),set_segment_xsym(i,5),0,0,0,0);
    end
    %set_segment_ysym : load blast의 압력을 받을 segment 지정
    fprintf(fileID ,'*SET_SEGMENT\n');
    %SID DA1 DA2 DA3 DA4 Solver ITS -
    fprintf(fileID,'%10d %9d %9d %9d %9d %9s %9d %9d\n',3,0,0,0,0,"MECH",0,0);
    for i = 1: ysym-1
    fprintf(fileID,'%10d %9d %9d %9d %9d %9d %9d %9d\n',set_segment_ysym(i,2),set_segment_ysym(i,3),set_segment_ysym(i,4),set_segment_ysym(i,5),0,0,0,0);
    end
    %}

    % 파일 닫기
    fclose(fileID);

end