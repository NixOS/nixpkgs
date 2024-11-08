{
  lib,
  stdenv,
  cygwin_headers,
  buildPackages,
  automake,
  autoconf,
  bison,
  cocom-tool-set,
  flex,
  perl,
  mingw_w64,
}:

stdenv.mkDerivation {
  pname = "cygwin";

  inherit (cygwin_headers)
    version
    src
    meta
    patches
    ;

  preConfigure = ''
    pushd winsup
    aclocal --force
    autoconf -f
    automake -ac
    rm -rf autom4te.cache
    popd
    patch -p0 -i ${./after-autogen.patch}
  '';

  postPatch = ''
    patchShebangs --build winsup/cygwin/scripts
  '';

  env.CXXFLAGS_FOR_TARGET = "-Wno-error";

  depsBuildBuild = [ buildPackages.stdenv.cc ];
  nativeBuildInputs = [
    autoconf
    automake
    bison
    cocom-tool-set
    flex
    perl
  ];
  buildInputs = [ mingw_w64 ];

  hardeningDisable = [ "fortify" ];
  configurePlatforms = [
    "build"
    "target"
  ];
  configureFlags = [
    "--disable-shared"
    "--disable-doc"
    "--enable-static"
    "--disable-dumper"
    "--with-cross-bootstrap"
    "ac_cv_prog_CC=gcc"
  ];
}
