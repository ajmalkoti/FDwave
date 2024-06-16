function mat_final=padarray_B_LR(mat_input,n)
mat_temp=mat_input;
for i=1:n
    mat_temp=pad1layer(mat_temp);
end

top_row=mat_temp(1,:);
mat_final=[top_row; top_row; mat_temp];

% mat_final=mat_temp;
% this function increases the size of matrix by 1 (at all sides), by replicating the sides 

end


function mat1layer=pad1layer(mat)
[nv,nh]= size(mat);

matt=zeros(nv+1,nh+2);      %imagesc(matt)

matt(1:nv,2:nh+1)= mat;      %imagesc(matt)

%sides
%bottom
matt(nv+1,2:nh+1)= mat(nv,1:nh);   %imagesc(matt)
%left
matt(1:nv,1)= mat(1:nv,1);   %imagesc(matt)
%right
matt(1:nv,nh+2)= mat(1:nv,nh);      %imagesc(matt)

%corners
%bottom left
matt(nv+1,1)= mat(nv,1);   %imagesc(matt)
%bottom right
matt(nv+1,nh+2)= mat(nv,nh);   %imagesc(matt)

mat1layer=matt;
end