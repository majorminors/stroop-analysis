function [fig,xpoints,means,sem] = make_params(vars,plottype,keep_holding)
% plots means with sem error bars connected with a line
% expects data row-wise, each row is a variable

if ~isempty(plottype)
    switch plottype
        case 'means'
            xpoints = 1:length(vars(:,1));
            for i = 1:length(vars(:,1))
                means(1,i) = mean(vars(i,:),'omitnan');
                sem(1,i) = nansem(vars(i,:));
            end
    end
end

if ~exist('keep_holding')
    keep_holding = 0;
end



fig = figure;
plot(xpoints,means,'*')
hold on
er = errorbar(xpoints,means,sem);
extendy = 10;
extendx = 1;
axis([min(xpoints)-extendx max(xpoints)+extendx min(means)-extendy max(means)+extendy]);
hold on
line(xpoints,means)
if ~keep_holding
    hold off
end

end