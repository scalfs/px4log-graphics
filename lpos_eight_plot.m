function [lpos, mode] = lpos_eight_plot(log);

data = load(log, 'LPOS', 'LPSP', 'STAT');
data_pioneer = load('logs_artigo/oito.txt');

lpos.re.lineno = data.LPOS(:,1);
lpos.re.x = -data.LPOS(:,2)+3.168;
lpos.re.y = -data.LPOS(:,3)+0.8205;
lpos.re.z = -data.LPOS(:,4);
lpos.re.z = lpos.re.z - min(lpos.re.z);

lpos.sp.lineno = data.LPSP(:,1);
lpos.sp.x = -data.LPSP(:,2);
lpos.sp.y = -data.LPSP(:,3);
lpos.sp.z = -data.LPSP(:,4);
lpos.sp.z = lpos.sp.z - min(lpos.sp.z);

mode.lineno = data.STAT(:,1);
mode.main = data.STAT(:,2);

oito.x = data_pioneer(:,1)/1000;
oito.y = data_pioneer(:,2)/1000;

% Rotate points to adjust to the trajectory
theta = -25;
theta = degtorad(theta);
rot = [cos(theta) -sin(theta); sin(theta) cos(theta)];
new_points = [lpos.re.x, lpos.re.y]*rot;

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

% Variables for ploting the desired trajectory
x = linspace (-1, 1, size(lpos.re.x, 1));
h = ones(1, size(lpos.re.x, 1))*mean(lpos.re.z(change1r:change2r));

p1 = plot3(new_points(1:change1r, 1), new_points(1:change1r, 2), lpos.re.z(1:change1r), 'Color', [0.6 0 0], 'LineWidth', 2.0);
p2 = plot3(new_points(change1r:change2r, 1), new_points(change1r:change2r, 2), lpos.re.z(change1r:change2r), 'Color', [0 0 0.6], 'LineWidth', 2.0);
p3 = plot3(new_points(change2r:end, 1), new_points(change2r:end, 2), lpos.re.z(change2r:end), 'Color', [0.6 0 0], 'LineWidth', 2.0);
p4 = plot3(11*cos(pi*x), 11*sin(2*pi*x)/2, h, 'Color', 'k', 'LineWidth', 2.0);
p5 = plot(oito.x - 11.001, oito.y - 0.002, 'Color', [0 0.6 0], 'LineWidth', 2.0);

legend([p1 p2 p4 p5], 'MANUAL Control', 'VISUAL Control', 'Desired Trajectory', 'Pioneer Trajectory', 'Location', 'SouthEast');

%% GPS Error

%[theta, rho] = cart2pol(new_points(change1r:change2r, 1), new_points(change1r:change2r, 2));


%err.hor = rho - cos(theta)^;
%err.z = lpos.re.z(change1r:change2r) - 10;

%err_ver = mean(err.z);
%std_ver = std(err.z);



%vertical = sqrt((err.x).^2 + (err.y).^2);
