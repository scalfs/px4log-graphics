function [lpos, yaw, mode] = graphics(log);

data = load(log, 'ATT', 'ATSP', 'LPOS', 'LPSP', 'STAT');

lpos.re.lineno = data.LPOS(:,1);
lpos.re.x = -data.LPOS(:,2);
lpos.re.y = -data.LPOS(:,3);
lpos.re.z = -data.LPOS(:,4);
lpos.re.z = lpos.re.z - min(lpos.re.z);

lpos.sp.lineno = data.LPSP(:,1);
lpos.sp.x = -data.LPSP(:,2);
lpos.sp.y = -data.LPSP(:,3);
lpos.sp.z = -data.LPSP(:,4);
lpos.sp.z = lpos.sp.z - min(lpos.sp.z);

att.re.lineno = data.ATT(:,1);
att.re.yaw = data.ATT(:,8);
att.sp.yaw = data.ATSP(:,4);

mode.lineno = data.STAT(:,1);
mode.main = data.STAT(:,2); 

% Look for the positions where the mode changed (manual to visual and otherwise) was made
for i = 1:size(mode.main)
    if mode.main(i) == 2 && mode.main(i+1) == 7 
        [change1r1, change1c1] = find(lpos.re.lineno > mode.lineno(i), 1, 'first');
        [change1r2, change1c2] = find(att.re.lineno > mode.lineno(i), 1, 'first');
    elseif mode.main(i) == 7 && mode.main(i+1) == 2
        [change2r1, change2c1] = find(lpos.re.lineno > mode.lineno(i), 1, 'first');
        [change2r2, change2c2] = find(att.re.lineno > mode.lineno(i), 1, 'first');

    end
end

%% Local Position Graphics
%figure
axis equal;
grid on;
hold on;
fontsize=12;
xlabel('X [m]', 'FontSize', fontsize);
ylabel('Y [m]', 'FontSize', fontsize);
zlabel('Z [m]', 'FontSize', fontsize);
set(gca,'FontSize',fontsize);

x = linspace (-1, 1, 653);
h = ones(1,653)*6;

p1 = plot3(lpos.re.x(1:change1r1), lpos.re.y(1:change1r1), lpos.re.z(1:change1r1), 'r', 'LineWidth', 2.0);
p2 = plot3(lpos.re.x(change1r1:change2r1), lpos.re.y(change1r1:change2r1), lpos.re.z(change1r1:change2r1), 'b', 'LineWidth', 2.0);
p3 = plot3(lpos.re.x(change2r1:end), lpos.re.y(change2r1:end), lpos.re.z(change2r1:end), 'r', 'LineWidth', 2.0);
%p3 = plot3(3.6*cos(2*pi*x),3.6*sin(2*pi*x),h,'k','LineWidth', 2.0);

legend([p1 p2],'MANUAL Control','VISUAL Control','Location','SouthEast');

%% Yaw Graphics
figure
axis auto;
grid on;
hold on;
fontsize=12;
xlabel('Flight Time [s]', 'FontSize', fontsize);
ylabel('Yaw [rad]', 'FontSize', fontsize);
set(gca,'FontSize',fontsize);

p4 = plot(att.re.yaw, 'k', 'LineWidth', 2.0)

legend('Yaw');