function FE_Modeling_Rigid(L,Dt,S,Fs,EL,folderName)

L = L*6; %ft to inch
Rigidwidth = 6 ;%[in]
Node_start_Rigid = (L-Rigidwidth)/EL;
Node_Number_L = L/EL+1;
Node_Number_D = L/EL+1;
Node_Number_Dt = Dt/EL+1;

node = zeros(Node_Number_L *Node_Number_Dt *(Node_Number_L-Node_start_Rigid),4);
element_solid = zeros(L/EL*(L-Rigidwidth)/EL*Dt/EL,10);

n=1;
if S==1
    for i = 1:Node_Number_Dt
        for j=1:Node_Number_L
            for k =Node_start_Rigid:Node_Number_L
                n = Node_Number_L*Node_Number_L*(i-1)+Node_Number_L*(j-1)+(k-1)+1;
                node(n,:,:,:) = [n,EL*(k-1),EL*(j-1),-EL*(i-1)];
            end
        end
    end
else
    for i = 1:Node_Number_Dt
        for j=1:Node_Number_L
            if j<Node_start_Rigid
                for k =Node_start_Rigid:Node_Number_L
                    node(n,:,:,:) = [n,EL*(k-1),EL*(j-1),-EL*(i-1)];
                    n=n+1;
                end
            else
                for k =1:Node_Number_L
                node(n,:,:,:) = [n,EL*(k-1),EL*(j-1),-EL*(i-1)];
                n=n+1;
                end
            end
        end
    end    
end

m=1;
   for i = 1:Dt/EL
        for j=1:L/EL
            if j<Rigidwidth/EL
                for k =Rigidwidth/EL:L/EL
                    n1 = (k-Rigidwidth)+(Rigidwidth/EL+1)*(j-1)+(Rigidwidth/EL+1)^2*(i-1)+1;
                    n2 = n1+1;
                    n4 = (k-Rigidwidth)+(Rigidwidth/EL+1)*(j)+(Rigidwidth/EL+1)^2*(i-1)+1;
                    n3 = n4+Rigidwidth;
                    n5 = (k-Rigidwidth)+(Rigidwidth/EL+1)*(j-1)+(Rigidwidth/EL+1)^2*(i)+1;
                    n6 = n5+1;
                    n8 = (k-Rigidwidth)+(Rigidwidth/EL+1)*(j)+(Rigidwidth/EL+1)^2*(i)+1;
                    n7 = n8+1;
                    element_solid(m,:,:,:) = [m,1,n1,n2,n3,n4,n5,n6,n7,n8];
                end
            else
                for k =1:L/EL
                    n1 = (k-1)+(L/EL+1)*(j-1)+(L/EL+1)^2*(i-1)+1;
                    n2 = n1+1;
                    n4 = (k-1)+(L/EL+1)*(j)+(L/EL+1)^2*(i-1)+1;
                    n3 = n4+1;
                    n5 = (k-1)+(L/EL+1)*(j-1)+(L/EL+1)^2*(i)+1;
                    n6 = n5+1;
                    n8 = (k-1)+(L/EL+1)*(j)+(L/EL+1)^2*(i)+1;
                    n7 = n8+1;
                    element_solid(m,:,:,:) = [m,1,n1,n2,n3,n4,n5,n6,n7,n8];
                    m=m+1;
                end
            end

        end
    end



%{
xsym = 1;
ysym = 1;
while xsym<L/EL*Dt/EL
    for i = 1:Dt/EL
        for j=1:L/EL
            for k =1:L/EL
                if k==1
                n1 = (k-1)+(L/EL+1)*(j-1)+(L/EL+1)^2*(i-1)+1;
                n2 = n1+1;
                n4 = (k-1)+(L/EL+1)*(j)+(L/EL+1)^2*(i-1)+1;
                n3 = n4+1;
                n5 = (k-1)+(L/EL+1)*(j-1)+(L/EL+1)^2*(i)+1;
                n6 = n5+1;
                n8 = (k-1)+(L/EL+1)*(j)+(L/EL+1)^2*(i)+1;
                n7 = n8+1;
                set_segment_xsym(xsym,:,:,:,:) = [xsym,n1, n4, n5,n8];   
                xsym=xsym+1;
                end
            end
        end
    end
end
while ysym<L/EL*Dt/EL
    for i = 1:Dt/EL
        for j=1:L/EL
            for k =1:L/EL
                if j==1
                n1 = (k-1)+(L/EL+1)*(j-1)+(L/EL+1)^2*(i-1)+1;
                n2 = n1+1;
                n4 = (k-1)+(L/EL+1)*(j)+(L/EL+1)^2*(i-1)+1;
                n3 = n4+1;
                n5 = (k-1)+(L/EL+1)*(j-1)+(L/EL+1)^2*(i)+1;
                n6 = n5+1;
                n8 = (k-1)+(L/EL+1)*(j)+(L/EL+1)^2*(i)+1;
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

    filePath = fullfile(newPath, 'gen_rigid.k'); % 파일 경로 설정
    fileID = fopen(filePath, 'w');
    fprintf(fileID ,'*KEYWORD\n'); % k 파일 시작
    fprintf(fileID ,'*NODE\n');
    for i = 1 : n-1
    fprintf(fileID,'%8d %15d %15d %15d %8d %8d \n',node(i,1),node(i,2),node(i,3),node(i,4),0,0);
    end
    fprintf(fileID ,'*ELEMENT_SOLID\n');
    for i = 1 : m-1
    fprintf(fileID,'%8d %7d %7d %7d %7d %7d %7d %7d %7d %7d\n',element_solid(i,1),element_solid(i,2),element_solid(i,3),element_solid(i,4),element_solid(i,5),element_solid(i,6),element_solid(i,7),element_solid(i,8),element_solid(i,9),element_solid(i,10));
    end




    % 파일 닫기
    fclose(fileID);

end