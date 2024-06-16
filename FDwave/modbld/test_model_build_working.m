nv=400;
nh=400;
A=zeros(nv,nh);
figure(1); 
subplot(2,2,1); imagesc(A); hold on
CVec={[200,200],[400,200],[400,300],[300,300],[200,200]};

H=[]; V=[];
for i=1:length(CVec)
   H= [H,CVec{i}(1)];
   V= [V,CVec{i}(2)];
end
figure(1);subplot(2,2,2); imagesc(A); hold on
plot(H,V)

indh=[]; indv=[];

for iv=1:nv %min(nvvec):max(nvvec)
    for ih=1:nh %min(nhvec):max(nhvec)
        in = inpolygon(ih,iv,H,V);
        if in==1;
            indh=[indh,ih];  
            indv=[indv,iv]; 
%             A(iv,ih)=1;
        end;
    end
end

figure(1); subplot(2,2,3);  imagesc(A); hold on; plot(indh,indv,'ro')

A(indv,indh)=1;
figure(1); subplot(2,2,4); imagesc(A);
