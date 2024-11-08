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

let
  newlib-cygwin = stdenv.mkDerivation {
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

    postInstall = ''
      mv $out/x86_64-pc-cygwin/* $out/
      rmdir $out/x86_64-pc-cygwin
    '';

    hardeningDisable = [
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
  };
in
# TODO: Is there something like nix-support which would achieve this better?
symlinkJoin {
  pname = "cygwin-and-mingw_w64";
  inherit (newlib-cygwin) version;
  paths = [
    newlib-cygwin
    mingw_w64
    mingw_w64.dev
  ];
}
