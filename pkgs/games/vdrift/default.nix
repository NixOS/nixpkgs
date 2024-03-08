{ lib
, stdenv
, fetchFromGitHub
, fetchsvn
, pkg-config
, scons
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
    rev = "1446";
    sha256 = "sha256-KEu49GAOfenPyuaUItt6W9pkuqUNpXgmTSFuc7ThljQ=";
  }
}:
let
  version = "unstable-2021-09-05";
  bin = stdenv.mkDerivation {
    pname = "vdrift";
    inherit version;

    src = fetchFromGitHub {
      owner = "vdrift";
      repo = "vdrift";
      rev = "7e9e00c8612b2014d491f026dd86b03f9fb04dcd";
      sha256 = "sha256-DrzRF4WzwEXCNALq0jz8nHWZ1oYTEsdrvSYVYI1WkTI=";
    };

    nativeBuildInputs = [ pkg-config scons ];
    buildInputs = [ libGLU libGL SDL2 SDL2_image libvorbis bullet curl gettext ];

    patches = [
      ./0001-Ignore-missing-data-for-installation.patch
    ];

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
