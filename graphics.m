function [lpos, yaw, mode] = graphics(log);

data = load(log, 'ATT', 'ATSP', 'LPOS', 'LPSP', 'STAT');

lpos.re.lineno = data.LPOS(:,1);
lpos.re.x = data.LPOS(:,2);
lpos.re.y = data.LPOS(:,3);
lpos.re.z = data.LPOS(:,4);

lpos.sp.lineno = data.LPSP(:,1);
lpos.sp.x = data.LPSP(:,2);
lpos.sp.y = data.LPSP(:,3);
lpos.sp.z = data.LPSP(:,4);

att.re.lineno = data.ATT(:,1);
att.re.yaw = data.ATT(:,8);
att.sp.yaw = data.ATSP(:,4);

mode.lineno = data.STAT(:,1);
mode.main = data.STAT(:,2); 

%% Grafico Posicao
figure
axis equal;
grid on;
hold on;
fontsize=12;
xlabel('X [m]', 'FontSize', fontsize);
ylabel('Y [m]', 'FontSize', fontsize);
zlabel('Z [m]', 'FontSize', fontsize);
set(gca,'FontSize',fontsize);

p1 = plot3(lpos.re.x, lpos.re.y, lpos.re.z);
p2 = plot3(lpos.re.x, lpos.re.y, lpos.re.z);
p3 = plot3(lpos.re.x, lpos.re.y, lpos.re.z);

legend([p1 p2],'Modo MANUAL','Modo OFFBOARD','Location','SouthEast');
