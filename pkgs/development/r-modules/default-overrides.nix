stdenv: pkgs: old: new: {
  RcppArmadillo = old.RcppArmadillo.overrideDerivation (attrs: {
    patchPhase = "patchShebangs configure";
  });

  rpf = old.rpf.overrideDerivation (attrs: {
    patchPhase = "patchShebangs configure";
  });

  BayesXsrc = old.BayesXsrc.overrideDerivation (attrs: {
    patches = [ ./patches/BayesXsrc.patch ];
  });

  rJava = old.rJava.overrideDerivation (attrs: {
    preConfigure = ''
      export JAVA_CPPFLAGS=-I${pkgs.jdk}/include/
      export JAVA_HOME=${pkgs.jdk}
    '';
  });

  JavaGD = old.JavaGD.overrideDerivation (attrs: {
    preConfigure = ''
      export JAVA_CPPFLAGS=-I${pkgs.jdk}/include/
      export JAVA_HOME=${pkgs.jdk}
    '';
  });

  Mposterior = old.Mposterior.overrideDerivation (attrs: {
    PKG_LIBS = "-L${pkgs.atlas}/lib -lf77blas -latlas";
  });

  qtbase = old.qtbase.overrideDerivation (attrs: {
    patches = [ ./patches/qtbase.patch ];
  });

  Rmpi = old.Rmpi.overrideDerivation (attrs: {
    configureFlags = [
      "--with-Rmpi-type=OPENMPI"
    ];
  });

  npRmpi = old.npRmpi.overrideDerivation (attrs: {
    configureFlags = [
      "--with-Rmpi-type=OPENMPI"
    ];
  });

  Rmpfr = old.Rmpfr.overrideDerivation (attrs: {
    configureFlags = [
      "--with-mpfr-include=${pkgs.mpfr}/include"
    ];
  });

  RVowpalWabbit = old.RVowpalWabbit.overrideDerivation (attrs: {
    configureFlags = [
      "--with-boost=${pkgs.boost.dev}" "--with-boost-libdir=${pkgs.boost.lib}/lib"
    ];
  });

  RAppArmor = old.RAppArmor.overrideDerivation (attrs: {
    patches = [ ./patches/RAppArmor.patch ];
    LIBAPPARMOR_HOME = "${pkgs.apparmor}";
  });

  RMySQL = old.RMySQL.overrideDerivation (attrs: {
    configureFlags = [
      "--with-mysql-dir=${pkgs.mysql}"
    ];
  });

  slfm = old.slfm.overrideDerivation (attrs: {
    PKG_LIBS = "-L${pkgs.atlas}/lib -lf77blas -latlas";
  });

  SamplerCompare = old.SamplerCompare.overrideDerivation (attrs: {
    PKG_LIBS = "-L${pkgs.atlas}/lib -lf77blas -latlas";
  });

  gputools = old.gputools.overrideDerivation (attrs: {
    patches = [ ./patches/gputools.patch ];
    CUDA_HOME = "${pkgs.cudatoolkit}";
  });

  # It seems that we cannot override meta attributes with overrideDerivation.
  CARramps = (old.CARramps.override { hydraPlatforms = stdenv.lib.platforms.none; }).overrideDerivation (attrs: {
    patches = [ ./patches/CARramps.patch ];
    configureFlags = [
      "--with-cuda-home=${pkgs.cudatoolkit}"
    ];
  });

  gmatrix = old.gmatrix.overrideDerivation (attrs: {
    patches = [ ./patches/gmatrix.patch ];
    CUDA_LIB_PATH = "${pkgs.cudatoolkit}/lib64";
    R_INC_PATH = "${pkgs.R}/lib/R/include";
    CUDA_INC_PATH = "${pkgs.cudatoolkit}/usr_include";
  });

  # It seems that we cannot override meta attributes with overrideDerivation.
  rpud = (old.rpud.override { hydraPlatforms = stdenv.lib.platforms.none; }).overrideDerivation (attrs: {
    patches = [ ./patches/rpud.patch ];
    CUDA_HOME = "${pkgs.cudatoolkit}";
  });

  WideLM = old.WideLM.overrideDerivation (attrs: {
    patches = [ ./patches/WideLM.patch ];
    configureFlags = [
      "--with-cuda-home=${pkgs.cudatoolkit}"
    ];
  });

  EMCluster = old.EMCluster.overrideDerivation (attrs: {
    patches = [ ./patches/EMCluster.patch ];
  });

  spMC = old.spMC.overrideDerivation (attrs: {
    patches = [ ./patches/spMC.patch ];
  });

  BayesLogit = old.BayesLogit.overrideDerivation (attrs: {
    patches = [ ./patches/BayesLogit.patch ];
  });

  BayesBridge = old.BayesBridge.overrideDerivation (attrs: {
    patches = [ ./patches/BayesBridge.patch ];
  });

  openssl = old.openssl.overrideDerivation (attrs: {
    patches = [ ./patches/openssl.patch ];
    OPENSSL_HOME = "${pkgs.openssl}";
  });

  Rserve = old.Rserve.overrideDerivation (attrs: {
    patches = [ ./patches/Rserve.patch ];
    configureFlags = [
      "--with-server" "--with-client"
    ];
  });

  nloptr = old.nloptr.overrideDerivation (attrs: {
    configureFlags = [
      "--with-nlopt-cflags=-I${pkgs.nlopt}/include"
      "--with-nlopt-libs='-L${pkgs.nlopt}/lib -lnlopt_cxx -lm'"
    ];
  });
}
