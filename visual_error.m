function [err_x, err_y, err_z, err_3d, std_dev] = visual_error(log);

datalog = load(log);

position.x = datalog(:,1);
position.y = datalog(:,2);
position.z = datalog(:,3) - 10;

err_x = mean(position.x)
err_y = mean(position.y)
err_z = mean(position.z)

euclidian = sqrt((position.x).^2 + (position.y).^2 + (position.z).^2); 
err_3d = mean(euclidian)
std_dev = std(euclidian);