function outp = findedges(A,t,params)
  lastV=A(1);
  trise = t(1);
  tfall = t(1);
  thr = params.thr;
  t0 = params.t0;
  t1 = params.t1;
  tol = params.tol;
    gtol = params.gtol;
  min = params.min;
  max = params.max;
  k=1;
  pp=1;
  leng = length(A);
  pan0high = ones(1,leng)*NaN;
  pan1high = ones(1,leng)*NaN;
  pan0low = ones(1,leng)*NaN;
  pan1low = ones(1,leng)*NaN;
  panx={};
  last_local_min = A(1);
  last_local_max = A(1);

  for i=1:leng
    val = A(i);
    tx = t(i);
    if val>thr && lastV<thr
      %%rising edge
      if last_local_min>min

        ss=tcomp(tx-tfall,t0,t1,tol);
        if ss==0
          pan0low(i)=thr*(1-gtol);
          panx{pp}(k) = 'l';
          k=k+1;
        elseif ss==1;
          pan1low(i)=thr*(1-gtol);
          panx{pp}(k) = 'h';
          k=k+1;
        else

          pp = pp+1;
          k=1;
        endif
        trise = tx;
      endif
      last_local_min  = thr;



    elseif val<thr && lastV>thr
      if last_local_max<max


        ss=tcomp(tx-trise,t0,t1,tol);
        if ss==0
          pan0high(i)=thr*(1+gtol);
          panx{pp}(k) = 'L';
          k=k+1;
        elseif ss==1;
          pan1high(i)=thr*(1+gtol);
          panx{pp}(k) = 'H';
          k=k+1;
        else

          pp = pp+1;
          k=1;
        endif
        tfall = tx;
        %%falling edge
      endif
      last_local_max  = thr;
      endif
    if val<last_local_min
      last_local_min = val;
    endif
    if val>last_local_max
      last_local_ax = val;
    endif

    lastV = val;
  end
  outp.panx = panx;
  outp.plow0 = pan0low;
  outp.plow1 = pan1low;
  outp.phigh0 = pan0high;
  outp.phigh1 = pan1high;

