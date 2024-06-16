function mat_final=padarray_TB_LR(mat_input,n)
mat_temp=mat_input;
for i=1:n
    mat_temp=pad1layer(mat_temp);
end
mat_final=mat_temp;
end




function mat1layer=pad1layer(mat)
% this function increases the size of matrix by 1 (at all sides), by replicating the sides 
[nv,nh]= size(mat);

matt=zeros(nv+2,nh+2);%imagesc(matt)

matt(2:nv+1,2:nh+1)= mat;%   imagesc(matt)

%sides
%top
matt(1,2:nh+1)= mat(1,1:nh);% imagesc(matt)
%bottom
matt(nv+2,2:nh+1)= mat(nv,1:nh); %imagesc(matt)
%left
matt(2:nv+1,1)= mat(1:nv,1);   %imagesc(matt)
%right
matt(2:nv+1,nh+2)= mat(1:nv,nh);  % imagesc(matt)

%corners
%top left
matt(1,1)= mat(1,1);   %imagesc(matt)
%top right
matt(1,nh+2)= mat(1,nh);   %imagesc(matt)
%bottom left
matt(nv+2,1)= mat(nv,1);   %imagesc(matt)
%bottom right
matt(nv+2,nh+2)= mat(nv,nh);   %imagesc(matt)
mat1layer=matt;
end