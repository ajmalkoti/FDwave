% Examaples of


% 1) Making a layer model
model_build_init('Wave_type','Elastic','nx',400,'nz',200,'dx',5,'dz',5)
% model_build_init('wave_type','Elastic','nx',400,'nz',200)
model_plot2

CVec={[1,200],[400,200],[400,100],[1,100]};
model_build_shape_arbitrary('coordinates',CVec,'Vp',2500,'Vs',2000,'Density',1600);
model_plot2


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 2) Building a complex model (wedge with dipping layers) 
%initialize a model with a homogeneous background
model_build_init('wave_Type','Elastic','nx',400,'nz',400,'dx',5,'dz',5,'vp',2000, 'vs',1800,'Density',1600)
model_plot2

% insert:  a wedge
CVec={[200,200],[400,200],[400,300],[300,300],[200,200]};
model_build_shape_arbitrary('coordinates',CVec,'vp',2800,'vs',2200,'Density',2000,'plotON','y');
model_plot2

% insert:  a dipping layer
CVec={[1,250],[400,300],[400,400],[200,400],[1,300],[1,250]};
model_build_shape_arbitrary('coordinates',CVec,'vp',2500,'vs',1900,'Density',1700,'plotON','y');
model_plot2

% insert: fill rest of part, a triangel
CVec={[1,300],[200,400],[1,400],[1,300]};
model_build_shape_arbitrary('coordinates',CVec,'vp',3100,'vs',2500,'Density',2100,'plotON','y');
model_plot2


