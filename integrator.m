clear all
close all
clc
A=[];
t=[];
lastT=0;


  [fname fpath fltidx] = uigetfile("*.mat", "Open files",'MultiSelect','on')
  for i=1:length(fname)
    data = load([fpath fname{i}]);
    leng = data.Length;
    Tint = data.Tinterval;
    t = [t ((1:leng)*Tint +lastT)];
    lastT = t(length(t));
    A = [A;data.A];
  endfor




Tinterval=Tint;
Tstart = 0;
Length = length(A);

[fname fpath fltidx] = uiputfile("*.mat", "Save file");
save([fpath fname],'A','Tinterval','Length','Tstart' );
