% read the CSV file into a table
T = readtable('id_to_users_mapping.csv');

% access a specific column of the table by its variable name
column = T.users;
x = column(1021);
disp(x);
disp(strcmp('A2CX7LUOHB2NDG', x{1}));
disp(x{1});