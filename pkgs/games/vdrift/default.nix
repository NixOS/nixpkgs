{ lib
, stdenv
, fetchFromGitHub
, fetchsvn
, pkg-config
, sconsPackages
, libGLU
, libGL
, SDL2
, SDL2_image
, libvorbis
, bullet
, curl
, gettext
, writeShellScriptBin

, data ? fetchsvn {
    url = "svn://svn.code.sf.net/p/vdrift/code/vdrift-data";
    rev = "1386";
    sha256 = "0ka6zir9hg0md5p03dl461jkvbk05ywyw233hnc3ka6shz3vazi1";
  }
}:
let
  version = "unstable-2017-12-09";
  bin = stdenv.mkDerivation {
    pname = "vdrift";
    inherit version;

    src = fetchFromGitHub {
      owner = "vdrift";
      repo = "vdrift";
      rev = "12d444ed18395be8827a21b96cc7974252fce6d1";
      sha256 = "001wq3c4n9wzxqfpq40b1jcl16sxbqv2zbkpy9rq2wf9h417q6hg";
    };

    nativeBuildInputs = [ pkg-config sconsPackages.scons_3_1_2 ];
    buildInputs = [ libGLU libGL SDL2 SDL2_image libvorbis bullet curl gettext ];

    patches = [ ./0001-Ignore-missing-data-for-installation.patch ];

    buildPhase = ''
      sed -i -e s,/usr/local,$out, SConstruct
      export CXXFLAGS="$(pkg-config --cflags SDL2_image)"
      scons -j$NIX_BUILD_CORES
    '';
    installPhase = "scons install";

    meta = {
      description = "Car racing game";
      homepage = "http://vdrift.net/";
      license = lib.licenses.gpl2Plus;
      maintainers = with lib.maintainers; [ viric ];
      platforms = lib.platforms.linux;
    };
  };
  wrappedName = "vdrift-${version}-with-data-${toString data.rev}";
in
(writeShellScriptBin "vdrift"  ''
  export VDRIFT_DATA_DIRECTORY="${data}"
  exec ${bin}/bin/vdrift "$@"
'').overrideAttrs (_: {
  name = wrappedName;
  meta = bin.meta // {
    hydraPlatforms = [ ];
  };
  unwrapped = bin;
  inherit bin data;
})
