function BC = bc_damp(cpath,BCtype,nAB )
%DAMP Summary of this function goes here
%   nAB : no of nodes used for damping
%   BCtype : type of BC viz. 'topFS' means top edge as free surface
%                            'allABC' means all sides as absorbing
%   default : nAB=25 & BCtype='allABC'
% switch nargin
%     case 0
%         nAB = 50;
%         BCtype='topFS';
%        
%     case 2
% %         disp(['    Input ABL layer nodes are       :  ', num2str(nAB)]);
% %         disp(['    Input type of top condition is  :  ', BCtype]);
%     otherwise
%         disp('Check input arguments')
% end


% disp(['    Default ABL layer nodes are       :  ', num2str(nAB)]);
% disp(['    Default type of top condition is  :  ', BCtype]);

BCname='ABL';

load([cpath,filesep,'Data_IP',filesep,'model'],'nh','nv');
BC = ones(nv,nh);
i=1:nAB;
wt = exp(-(0.0053*(nAB-i)).^2);

if strcmp(BCtype,'topFS')
    for k=1:length(wt)
        BC(1:nv-k+1,k) = wt(k); %left BC
        BC(nv-k+1,k:nh-k+1)= wt(k); %Bottom BC
        BC(1:nv-k+1, nh-k+1)= wt(k);    % Right BC
    end
    
elseif strcmp(BCtype,'topABC')
    for k=1:length(wt)
        BC(k,k:nh-k+1)= wt(k); %Top BC
        BC(k:nv-k+1,k) = wt(k); %left BC
        BC(nv-k+1,k:nh-k+1)= wt(k); %Bottom BC
        BC(k:nv-k+1, nh-k+1)= wt(k);    % Right BC
    end
    
end

% figure();  imagesc(BC)
% 
% str=strcat(pwd,'\Data_IP\BC');
% save(str,'BC','nAB','BCtype','BCname');

end

