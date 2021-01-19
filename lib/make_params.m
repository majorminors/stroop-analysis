function [fig,xpoints,means,sem] = make_params(vars)

xpoints = 1:length(vars(:,1));
for i = 1:length(vars(:,1))
   means(1,i) = nanmean(vars(i,:));
   sem(1,i) = nansem(vars(i,:));
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
hold off

end