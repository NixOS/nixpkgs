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
  symlinkJoin,
}:

stdenv.mkDerivation {
  pname = "cygwin";

  inherit (cygwin_headers)
    version
    src
    meta
    ;

  outputs = [
    "out"
    "bin"
    "dev"
    "man"
  ];

  patches = cygwin_headers.patches ++ [ ./store-tls-pointer-in-win32-tls.patch ];

  postPatch = ''
    patchShebangs --build winsup/cygwin/scripts
  '';

  preConfigure = ''
    pushd winsup
    aclocal --force
    autoconf -f
    automake -ac
    rm -rf autom4te.cache
    popd
    patch -p0 -i ${./after-autogen.patch}
    mkdir "../build"
    cd "../build"
    configureScript="../$sourceRoot/configure"
  '';

  env.CXXFLAGS_FOR_TARGET = toString [
    "-Wno-error=register"
    "-L${lib.getLib mingw_w64}/lib/w32api"
  ];

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

  enableParallelBuilding = true;

  makeFlags = [ "tooldir=$(out)" ];

  # this is explicitly -j1 in cygwin.cygport
  # without it the install order is non-deterministic
  enableParallelInstalling = false;

  hardeningDisable = [
    # conflicts with internal definition of 'bzero'
    "fortify"
    "stackprotector"
  ];
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

  allowedImpureDLLs = [ "ntdll.dll" ];

  passthru.w32api = mingw_w64;
}
