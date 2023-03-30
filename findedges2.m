function outp = findedges2(A,t,params)
  lastV=A(1);
  trise = t(1);
  tfall = t(1);
  thr = params.thr;

  tol = params.tol;

  gtol = params.gtol;
  min = params.min;
  max = params.max;
  kbps = params.kbps
  k=1;
  pp=0;
  leng = length(A);
  pan = ones(1,leng)*NaN;
  panx={};
  panv={};
  last_local_min = A(1);
  last_local_max = A(1);
  Tbit = 1/(kbps*1000)
  lastedge=t(1);
  state=0;
  for i=1:leng
    val = A(i);
    tx = t(i);
    if (tx-lastedge)>=3*Tbit*(1+tol)
      if (state !=0)
        if k <=2 ;
          if pp>0

            pp=pp-1;

          endif
        endif
        state = 0;
      endif

    endif
    if val>thr && lastV<thr || val<thr && lastV>thr
      if val>thr && lastV<thr
        edgeVal = 1;
      else
        edgeVal = 0;
      endif
      %%rising edge
      if state == 0 % detecto primer flanco
        if edgeVal == 0

          lastedge = tx;
          state = 2;
          pp=pp+1;
          k=1;
          pan(i)=thr*(1+(2*edgeVal-1)*gtol);
##          if edgeVal == 1
##            panx{pp}(k) = '1';
##
##          else
           panx{pp}(k) = '0';
##
##          endif
         k=k+1;
##          lastedge = tx;
##          state = 2;

        endif

      elseif state == 1 || state == 2;
        if (tx-lastedge)>=state*Tbit*(1-tol) && (tx-lastedge)<=state*Tbit*(1+tol)
          %% es un bit valido
          pan(i)=thr*(1+(2*edgeVal-1)*gtol);
          if edgeVal == 1
            panx{pp}(k) = '1';

          else
            panx{pp}(k) = '0';

        endif

          k=k+1;
           if (mod(k,9)==0)
            panx{pp}(k) = ' ';
            k=k+1;
          endif
          lastedge = tx;
          state = 2;
        elseif (tx-lastedge)<Tbit*(1-tol)
          %% ignoro
        elseif (tx-lastedge)>=2*Tbit*(1+tol)


          state=1;
          pp=pp+1;
          k=1;
          lastedge = tx;

        endif
      endif
    endif







    lastV = val;
  end
  for j=1:length(panx)
    panv{j,1}=0;
    pos = 7;
    px=1;
    val=0;
    for k=1:length(panx{j})

      if panx{j}(k) != ' '
        val = val + (panx{j}(k)-'0')*2^(pos);
        panv{j,1} = panv{j,1} + (panx{j}(k)-'0')*2^(pos);
        pos =  pos-1;
      else
        pand(j,px) = val;
        px = px+1;
        val = 0;
        pos = 7;
      endif

    endfor
    panv{j,2}=dec2hex(panv{j,1});
  endfor
  outp.panv = panv
  outp.panx = panx;
  outp.pan = pan;
  outp.pand = pand;

