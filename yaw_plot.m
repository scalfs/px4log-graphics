function [yaw, mode] = yaw_plot(log);

data = load(log, 'ATT', 'ATSP', 'STAT', 'GPS');

att.re.lineno = data.ATT(:,1);
att.re.yaw = data.ATT(:,8)/pi * 180;
att.sp.yaw = data.ATSP(:,4)/pi * 180;

mode.lineno = data.STAT(:,1);
mode.main = data.STAT(:,2);

gps.time = data.GPS(:,2);

% Look for the positions where the mode changed (manual to visual and otherwise) was made
for i = 1:size(mode.main)
    if mode.main(i) == 2 && mode.main(i+1) == 7 
        [change1r, change1c] = find(att.re.lineno > mode.lineno(i+4), 1, 'first');
    elseif mode.main(i) == 7 && mode.main(i+1) == 2
        [change2r, change2c] = find(att.re.lineno > mode.lineno(i+1), 1, 'first');
    end
end

%% Yaw Graphics
figure
grid off;
hold on;
fontsize=12;
xlabel('Flight Time [mm:ss]', 'FontSize', fontsize);
ylabel('Yaw [degrees]', 'FontSize', fontsize);
set(gca,'FontSize',fontsize);

delta_t = gps.time(end) - gps.time(1);
delta_t = floor(delta_t/10^6);

t = linspace (0, delta_t, size(att.re.yaw,1));
xdate = datenum(0,0,0,0,0,t);

p2 = rectangle('Position',[0,-200,xdate(change1r),400], 'FaceColor', [230/255 255/255 230/255], 'DisplayName', 'MANUAL Control');
p3 = rectangle('Position',[xdate(change1r),-200,xdate(change2r),400], 'FaceColor', [230/255 230/255 255/255], 'DisplayName', 'VISUAL Control');
p4 = rectangle('Position',[xdate(change2r),-200,xdate(end),400], 'FaceColor', [230/255 255/255 230/255], 'DisplayName', 'MANUAL Control');

p1 = plot(xdate, att.re.yaw, 'Color', [0 0 128/255], 'LineWidth', 2.0);
%set(gca,'XTick',[0.0; 0.0002; 0.0004; 0.0006; 0.0008; 0.00010; 0.0012])
datetick('x','MM:SS')
axis ([0 xdate(end) -200 200]);
legend([p1 p2 p3], 'Yaw', 'MANUAL Control', 'VISUAL Control', 'Location', 'SouthEast');