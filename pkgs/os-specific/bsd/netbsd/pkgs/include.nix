{
  lib,
  mkDerivation,
  bsdSetupHook,
  netbsdSetupHook,
  makeMinimal,
  install,
  mandoc,
  groff,
  nbperf,
  rpcgen,
  defaultMakeFlags,
  stdenv,
}:

mkDerivation {
  noLibc = true;
  path = "include";
  nativeBuildInputs = [
    bsdSetupHook
    netbsdSetupHook
    makeMinimal
    install
    mandoc
    groff
    nbperf
    rpcgen
  ];

  # The makefiles define INCSDIR per subdirectory, so we have to set
  # something else on the command line so those definitions aren't
  # overridden.
  postPatch = ''
    find "$BSDSRCDIR" -name Makefile -exec \
      sed -i -E \
        -e 's_/usr/include_''${INCSDIR0}_' \
        {} \;
  '';

  # multiple header dirs, see above
  postConfigure = ''
    makeFlags=''${makeFlags/INCSDIR/INCSDIR0}
  '';

  extraPaths = [ "common" ];
  headersOnly = true;
  noCC = true;
  meta.platforms = lib.platforms.netbsd;
  makeFlags = defaultMakeFlags ++ [ "RPCGEN_CPP=${stdenv.cc.cc}/bin/cpp" ];
}
