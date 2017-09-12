function [lpos, mode] = lpos_plot(log);

data = load(log, 'LPOS', 'LPSP', 'STAT');

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

mode.lineno = data.STAT(:,1);
mode.main = data.STAT(:,2);

% Look for the positions where the mode changed (manual to visual and otherwise) was made
for i = 1:size(mode.main)
    if mode.main(i) == 2 && mode.main(i+1) == 7 
        [change1r, change1c] = find(lpos.re.lineno > mode.lineno(i), 1, 'first');
    elseif mode.main(i) == 7 && mode.main(i+1) == 2
        [change2r, change2c] = find(lpos.re.lineno > mode.lineno(i), 1, 'first');
    end
end

%% Local Position Graphics
figure
axis equal;
grid on;
hold on;
fontsize=12;
xlabel('X [m]', 'FontSize', fontsize);
ylabel('Y [m]', 'FontSize', fontsize);
zlabel('Z [m]', 'FontSize', fontsize);
set(gca,'FontSize',fontsize);

az = -138;
el = 44;

x = linspace (-1, 1, size(lpos.re.x, 1));
h = ones(1, size(lpos.re.x, 1))*mean(lpos.re.z(change1r:change2r));

p1 = plot3(lpos.re.x(1:change1r), lpos.re.y(1:change1r), lpos.re.z(1:change1r), 'Color', [0.6 0 0], 'LineWidth', 2.0);
p2 = plot3(lpos.re.x(change1r:change2r), lpos.re.y(change1r:change2r), lpos.re.z(change1r:change2r), 'Color', [0 0 0.6], 'LineWidth', 2.0);
p3 = plot3(lpos.re.x(change2r:end), lpos.re.y(change2r:end), lpos.re.z(change2r:end), 'Color', [0.6 0 0], 'LineWidth', 2.0);
p4 = plot3(3.8*cos(2*pi*x)+3,3.8*sin(2*pi*x)-1.5,h,'k','LineWidth', 2.0);

centers = [3 -1.5];
radii = 3.8;
p5 = viscircles(centers,radii, 'EdgeColor', [0 0.6 0]);

legend([p1 p2 p4 p5],'MANUAL Control','VISUAL Control','Desired Trajectory','Pioneer Trajectory','Location','SouthEast');