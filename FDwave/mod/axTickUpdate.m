function axTickUpdate()

if verLessThan('matlab','8.4')
    AX = findobj(gcf, 'type','axes');
    for i=1:length(AX)
        ax=AX(i);
        h=get(ax,'UserData');    % h=[dh,dv];
        if ~isempty(h)
            xtk=h(1)*get(ax,'XTick');    set(ax,'XTickLabel',xtk);
            ytk=h(2)*get(ax,'YTick');    set(ax,'YTickLabel',ytk);
        end
    end
else
    % works in MATLAB 2014 above
    
    AX = findobj(gcf, 'type','axes');
    for i=1:length(AX)
        ax=AX(i);
        ax.XTickLabel = ax.UserData.dh.*ax.XTick;
        ax.YTickLabel = ax.UserData.dv.*ax.YTick;
    end
end

end