clear all
close all
clc
[fname fpath fltidx] = uigetfile("*.mat");
data = load([fpath fname]);
leng = data.Length;
t = (1:leng)*data.Tinterval + data.Tstart;
A = data.A;

vted = 2;
vpan = 1;

tol = 0.30;
gtol = 0.03;
  params.thr = vted;
  params.tol = tol;
  params.kbps=9.6;
  params.gtol = gtol;

  params.min = 5;
  params.max = 30;
panel = findedges2(A,t,params);
px = panel.panx
length(px{1})
pand = panel.pand
plot(t,A,t,panel.pan,'ob');

