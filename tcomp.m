function a = tcomp(t,t0,t1,tol)
  if t>t0*(1-tol) && t<t0*(1+tol)
    a=0;
  elseif t>t1*(1-tol) && t<t1*(1+tol)
    a=1;
  else
    a=NaN;
  endif

