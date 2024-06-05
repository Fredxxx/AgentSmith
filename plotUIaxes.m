function plotUIaxes(data, t, ax, plotInd, xFirst, xLast)
    cla(ax)
    legLab = ["DataCh1" "DataCh2" "DataCh3" "DataCh4" "Trigger" "VoltageApp"];
    for i = 1:length(plotInd)
        ind = plotInd(i);
        if ind == 5
            plot(ax, t, abs(data(ind,:)*max(max(data(6,:)))*250/3)), hold(ax,"on")
        else
            plot(ax, t, data(ind,:)), hold(ax,"on")
        end
        leg{i} = legLab(ind); 
        %plot(ax, t, abs(data(5,:)*max(data(6,:)*250/3)))
        %legend(ax, 'Voltage Pulse', 'Trigger')
        %xlim([3.572, 3.586])
        %xlim(ax,[xFirst, xLast])
    end
    legend(ax, leg)
    xlim(ax,[xFirst, xLast])
end