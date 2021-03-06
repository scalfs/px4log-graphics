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

p1 = plot3(lpos.re.x(1:change1r), lpos.re.y(1:change1r), lpos.re.z(1:change1r), 'Color', [0.6 0 0], 'LineWidth', 2.0);
p2 = plot3(lpos.re.x(change1r:change2r), lpos.re.y(change1r:change2r), lpos.re.z(change1r:change2r), 'Color' , [0 0 0.6], 'LineWidth', 2.0);
p3 = plot3(lpos.re.x(change2r:end), lpos.re.y(change2r:end), lpos.re.z(change2r:end), 'Color', [0.6 0 0], 'LineWidth', 2.0);


x = [-11.32; -4.792; -9.386; -1.766; -3.539];
y = [11.67; 11.14; 5.062; 6.474; -0.3974];
h = mean(lpos.re.z(change1r:change2r))*ones(1, size(x,1));

p4 = plot3(x, y, h, 'Color', 'k', 'LineWidth', 2.0);
p5 = plot(x, y, 'Color', [0 0.6 0], 'LineWidth', 2.0);

%p4 = plot3(lpos.sp.x(1:change1r), lpos.sp.y(1:change1r), lpos.sp.z(1:change1r), 'k', 'LineWidth', 2.0);
%p5 = plot3(lpos.sp.x(change1r:change2r), lpos.sp.y(change1r:change2r), lpos.sp.z(change1r:change2r), 'c', 'LineWidth', 2.0);
%p6 = plot3(lpos.sp.x(change2r:end), lpos.sp.y(change2r:end), lpos.sp.z(change2r:end), 'k', 'LineWidth', 2.0);

legend([p1 p2 p4 p5], 'MANUAL Control', 'VISUAL Control', 'Desired Trajectory', 'Pioneer Trajectory', 'Location', 'SouthEast');