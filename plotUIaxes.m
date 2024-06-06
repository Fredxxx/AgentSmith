function plotUIaxes(data, t, ax, plotInd, xSmart)
    if isempty(plotInd)
        cla(ax)
    else
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
        if xSmart(1) == 1
            xlim(ax,[xSmart(2), xSmart(3)])
        else
            xlim(ax,[min(t), max(t)])
        end
    end
end