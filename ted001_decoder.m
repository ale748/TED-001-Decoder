clear all
close all
clc
[fname fpath fltidx] = uigetfile();
data = load([fpath fname]);
leng = data.Length;
t = (1:leng)*data.Tinterval + data.Tstart;
A = data.A;

vted = 10;
vpan = 1;
t0=100e-6;
t1 = 200e-6;
tol = 0.30;
lastV = A(1);
tfstartp = t(1);
tfstart = t(1);
pan0 = ones(1,leng)*NaN;
pan1 = ones(1,leng)*NaN;
ted0 = ones(1,leng)*NaN;
ted1 = ones(1,leng)*NaN;
la=0;
k=1;
kt=1;
panx={};
tedx={};
pp=0;
pt=0;
lasttpan=t(1);
lasttted=t(1);

panxx=[];
pank=1;
trise =
for i=1:leng
  val = A(i);
  tx = t(i);
  if val>thr && lastV<thr
    %%rising edge
    ss=tcomp(tx-tfall,t0,t1);
    if ss==0
      pan0low(i)=thr*(1-tol);
      panx{pp}(k) = 'l';
      k=k+1;
    elseif ss==1;
      pan1low(i)=thr*(1-tol);
      panx{pp}(k) = 'h';
      k=k+1;
    else

      pp = pp+1;
      k=1;
    endif
    trise = tx;


  elseif val<thr && lastV>thr
    ss=tcomp(tx-trise,t0,t1);
    if ss==0
      pan0high(i)=thr*(1-tol);
      panx{pp}(k) = 'L';
      k=k+1;
    elseif ss==1;
      pan1high(i)=thr*(1-tol);
      panx{pp}(k) = 'H';
      k=k+1;
    else

      pp = pp+1;
      k=1;
    endif
    tfall = tx;
    %%falling edge
  endif
end









  if A(i)<vpan && lastV>=vpan
    tfstartp = t(i);
  elseif A(i)>vpan && lastV<=vpan
    tx = t(i)-tfstartp;
    if tx>t0*(1-tol) && tx<t0*(1+tol)
      if t(i)-lasttpan>2*t1*(1+tol)

        pp=pp+1;
        k=1;
      endif
      lasttpan = t(i);
      pan0(i)=vpan;
      panx{pp}(k)='0';
      k=k+1;
    elseif tx>t1*(1-tol) && tx<t1*(1+tol)
      if t(i)-lasttpan>2*t1*(1+tol)

        pp=pp+1;
        k=1;
      endif
      lasttpan = t(i);
      pan1(i)=vpan;
      panx{pp}(k)='1';
      k=k+1;
    else
      pan0(i)=NaN;
      pan1(i)=NaN;
    endif
  endif

    if A(i)<vted && lastV>=vted
    tfstart = t(i);
  elseif A(i)>vted && lastV<=vted
    tx = t(i)-tfstart;
    if tx>t0*(1-tol) && tx<t0*(1+tol)


      if t(i)-lasttted>2*t1*(1+tol)
      kt=1;
        pt=pt+1;
      endif
      lasttted = t(i);
      ted0(i)=vted;
      tedx{pt}(kt)='0';
      kt=kt+1;
    elseif tx>t1*(1-tol) && tx<t1*(1+tol)
      if t(i)-lasttted>2*2*t1*(1+tol)
        kt=1;
        pt=pt+1;
      endif
      lasttted = t(i);
      ted1(i)=vted;
      tedx{pt}(kt)='1';
      kt=kt+1;
    else
      ted0(i)=NaN;
      ted1(i)=NaN;
    endif
  elseif A(i)<vpan
    tfstart = t(i);
  endif

  lastV = A(i);
end
for j=1:length(panx)
  kn=length(panx{1,j});
  panx{2,j}=0;
  for n=1:kn;
    panx{2,j} = panx{2,j} + (panx{1,j}(n)-'0')*2^(n-1);

  end
  panx{3,j} = dec2hex(panx{2,j});
    panx{4,j} = kn;
end

for j=1:length(tedx)
  kn=length(tedx{1,j});
  tedx{2,j}=0;
  for n=1:kn;
    tedx{2,j} = tedx{2,j} + (tedx{1,j}(n)-'0')*2^(n-1);
  end
  tedx{3,j} = dec2hex(tedx{2,j});

    tedx{4,j} = kn;

end


figure
plot(t,A,t,pan0,'o',t,pan1,'+',t,ted0,'o',t,ted1,'+')
panx
tedx
