{
  lib,
  mkDerivation,
  bsdSetupHook,
  netbsdSetupHook,
  makeMinimal,
  install,
  mandoc,
  groff,
  rsync,
  nbperf,
  rpcgen,
  common,
  defaultMakeFlags,
  stdenv,
}:

mkDerivation {
  path = "include";
  version = "9.2";
  sha256 = "0nxnmj4c8s3hb9n3fpcmd0zl3l1nmhivqgi9a35sis943qvpgl9h";
  nativeBuildInputs = [
    bsdSetupHook
    netbsdSetupHook
    makeMinimal
    install
    mandoc
    groff
    rsync
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

  extraPaths = [ common ];
  headersOnly = true;
  noCC = true;
  meta.platforms = lib.platforms.netbsd;
  makeFlags = defaultMakeFlags ++ [ "RPCGEN_CPP=${stdenv.cc.cc}/bin/cpp" ];
}
