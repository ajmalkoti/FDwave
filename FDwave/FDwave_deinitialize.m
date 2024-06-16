function FDwave_deinitialize(cp)
rmpath([cp,filesep,'ana'])
rmpath([cp,filesep,'asol'])
rmpath([cp,filesep,'bc'])
rmpath([cp,filesep,'cal'])
rmpath([cp,filesep,'geo'])
rmpath([cp,filesep,'mod'])
rmpath([cp,filesep,'modbld'])
rmpath([cp,filesep,'modd']);
rmpath([cp,filesep,'src'])

%%%%%%%%%%% for GUI %%%%%%%%%%%%%%%%
% rmpath([cp,filesep,'GUI'])

%%%%%%%%% for extra Package %%%%%%%%%
%rmpath(genpath([cp,filesep,'O']));


end