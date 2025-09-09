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
      ;

    outputs = [
      "out"
      "bin"
      "dev"
      "man"
    ];

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

    enableParallelBuilding = true;

    makeFlags = [ "tooldir=$(out)" ];

    # this is explicitly -j1 in cygwin.cygport
    # without it the install order is non-deterministic
    enableParallelInstalling = false;

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

    passthru.w32api = mingw_w64;
  };
in
newlib-cygwin
# # TODO: Is there something like nix-support which would achieve this better?
# symlinkJoin {
#   pname = "cygwin-and-mingw_w64";
#   inherit (newlib-cygwin) version;
#   paths = [
#     newlib-cygwin
#     mingw_w64
#     mingw_w64.dev
#   ];
# }
