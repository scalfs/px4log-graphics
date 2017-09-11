function [yaw, mode] = yaw_plot(log);

data = load(log, 'ATT', 'ATSP', 'STAT', 'GPS');

att.re.lineno = data.ATT(:,1);
att.re.yaw = data.ATT(:,8);
att.sp.yaw = data.ATSP(:,4);

mode.lineno = data.STAT(:,1);
mode.main = data.STAT(:,2);

gps.time = data.GPS(:,2);

% Look for the positions where the mode changed (manual to visual and otherwise) was made
for i = 1:size(mode.main)
    if mode.main(i) == 2 && mode.main(i+1) == 7 
        [change1r, change1c] = find(att.re.lineno > mode.lineno(i), 1, 'first');
    elseif mode.main(i) == 7 && mode.main(i+1) == 2
        [change2r, change2c] = find(att.re.lineno > mode.lineno(i), 1, 'first');
    end
end

%% Yaw Graphics
figure
axis auto;
grid off;
hold on;
fontsize=12;
xlabel('Flight Time [mm:ss]', 'FontSize', fontsize);
ylabel('Yaw [rad]', 'FontSize', fontsize);
set(gca,'FontSize',fontsize);

delta_t = gps.time(end) - gps.time(1);
delta_t = floor(delta_t/10^6);

t = linspace (0, delta_t, size(att.re.yaw,1));
xdate = datenum(0,0,0,0,0,t);

p6 = plot(xdate, att.re.yaw, 'k', 'LineWidth', 2.0);

datetick('x','MM:SS')

legend('Yaw');