overrideDerivation: pkgs: old: new: {
  RcppArmadillo = overrideDerivation old.RcppArmadillo (attrs: {
    patchPhase = "patchShebangs configure";
  });

  rpf = overrideDerivation old.rpf (attrs: {
    patchPhase = "patchShebangs configure";
  });

  BayesXsrc = overrideDerivation old.BayesXsrc (attrs: {
    patches = [ ./patches/BayesXsrc.patch ];
  });

  rJava = overrideDerivation old.rJava (attrs: {
    preConfigure = ''
      export JAVA_CPPFLAGS=-I${pkgs.jdk}/include/
      export JAVA_HOME=${pkgs.jdk}
    '';
  });

  JavaGD = overrideDerivation old.JavaGD (attrs: {
    preConfigure = ''
      export JAVA_CPPFLAGS=-I${pkgs.jdk}/include/
      export JAVA_HOME=${pkgs.jdk}
    '';
  });

  Mposterior = overrideDerivation old.Mposterior (attrs: {
    PKG_LIBS = "-L${pkgs.atlas}/lib -lf77blas -latlas";
  });

  qtbase = overrideDerivation old.qtbase (attrs: {
    patches = [ ./patches/qtbase.patch ];
  });

  Rmpi = overrideDerivation old.Rmpi (attrs: {
    configureFlags = [
      "--with-Rmpi-type=OPENMPI"
    ];
  });

  npRmpi = overrideDerivation old.npRmpi (attrs: {
    configureFlags = [
      "--with-Rmpi-type=OPENMPI"
    ];
  });

  Rmpfr = overrideDerivation old.Rmpfr (attrs: {
    configureFlags = [
      "--with-mpfr-include=${pkgs.mpfr}/include"
    ];
  });

  RVowpalWabbit = overrideDerivation old.RVowpalWabbit (attrs: {
    configureFlags = [
      "--with-boost=${pkgs.boost.dev}" "--with-boost-libdir=${pkgs.boost.lib}/lib"
    ];
  });

  RAppArmor = overrideDerivation old.RAppArmor (attrs: {
    patches = [ ./patches/RAppArmor.patch ];
    LIBAPPARMOR_HOME = "${pkgs.apparmor}";
  });

  RMySQL = overrideDerivation old.RMySQL (attrs: {
    configureFlags = [
      "--with-mysql-dir=${pkgs.mysql}"
    ];
  });

  slfm = overrideDerivation old.slfm (attrs: {
    PKG_LIBS = "-L${pkgs.atlas}/lib -lf77blas -latlas";
  });

  SamplerCompare = overrideDerivation old.SamplerCompare (attrs: {
    PKG_LIBS = "-L${pkgs.atlas}/lib -lf77blas -latlas";
  });

  gputools = overrideDerivation old.gputools (attrs: {
    patches = [ ./patches/gputools.patch ];
    CUDA_HOME = "${pkgs.cudatoolkit}";
  });

  CARramps = overrideDerivation old.CARramps (attrs: {
    patches = [ ./patches/CARramps.patch ];
    configureFlags = [
      "--with-cuda-home=${pkgs.cudatoolkit}"
    ];
  });

  gmatrix = overrideDerivation old.gmatrix (attrs: {
    patches = [ ./patches/gmatrix.patch ];
    CUDA_LIB_PATH = "${pkgs.cudatoolkit}/lib64";
    R_INC_PATH = "${pkgs.R}/lib/R/include";
    CUDA_INC_PATH = "${pkgs.cudatoolkit}/usr_include";
  });

  rpud = overrideDerivation old.rpud (attrs: {
    patches = [ ./patches/rpud.patch ];
    CUDA_HOME = "${pkgs.cudatoolkit}";
  });

  WideLM = overrideDerivation old.WideLM (attrs: {
    patches = [ ./patches/WideLM.patch ];
    configureFlags = [
      "--with-cuda-home=${pkgs.cudatoolkit}"
    ];
  });

  EMCluster = overrideDerivation old.EMCluster (attrs: {
    patches = [ ./patches/EMCluster.patch ];
  });

  spMC = overrideDerivation old.spMC (attrs: {
    patches = [ ./patches/spMC.patch ];
  });

  BayesLogit = overrideDerivation old.BayesLogit (attrs: {
    patches = [ ./patches/BayesLogit.patch ];
  });

  BayesBridge = overrideDerivation old.BayesBridge (attrs: {
    patches = [ ./patches/BayesBridge.patch ];
  });

  dbarts = overrideDerivation old.dbarts (attrs: {
    patches = [ ./patches/dbarts.patch ];
  });

  openssl = overrideDerivation old.openssl (attrs: {
    patches = [ ./patches/openssl.patch ];
    OPENSSL_HOME = "${pkgs.openssl}";
  });

  Rserve = overrideDerivation old.Rserve (attrs: {
    patches = [ ./patches/Rserve.patch ];
    configureFlags = [
      "--with-server" "--with-client"
    ];
  });

  nloptr = overrideDerivation old.nloptr (attrs: {
    configureFlags = [
      "--with-nlopt-cflags=-I${pkgs.nlopt}/include"
      "--with-nlopt-libs='-L${pkgs.nlopt}/lib -lnlopt_cxx -lm'"
    ];
  });
}
