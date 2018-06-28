clear, clc, close all

log = 'logs_artigo/circle-pose.txt';

datalog = load(log);

position.x = datalog(:,2);
position.y = datalog(:,3);
position.z = datalog(:,4) - 10;

axis auto
plot3(position.x,position.y,position.z,'.')

[theta, rho] = cart2pol(position.x, position.y);

err.hor = rho - radius;
err.z = lpos.re.z(change1r:change2r) - 10;

err_ver = mean(err.z)
std_ver = std(err.z)
max_ver = max(abs(err.z))

err_hor = mean(err.hor)
std_hor = std(err.hor)
max_hor = max(abs(err.hor))