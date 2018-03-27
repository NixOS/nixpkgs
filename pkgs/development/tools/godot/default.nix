{ stdenv, lib, fetchFromGitHub, scons, pkgconfig, libX11, libXcursor
, libXinerama, libXrandr, libXrender, libpulseaudio ? null
, libXi ? null, libXext, libXfixes, freetype, openssl
, alsaLib, libGLU, zlib, yasm ? null }:

let
  options = {
    touch = libXi != null;
    pulseaudio = false;
  };
in stdenv.mkDerivation rec {
  name    = "godot-${version}";
  version = "3.0.2";

  src = fetchFromGitHub {
    owner  = "godotengine";
    repo   = "godot";
    rev    = "${version}-stable";
    sha256 = "1ca1zznb7qqn4vf2nfwb8nww5x0k8fc4lwjvgydr6nr2mn70xka4";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    scons libX11 libXcursor libXinerama libXrandr libXrender
    libXi libXext libXfixes freetype openssl alsaLib libpulseaudio
    libGLU zlib yasm
  ];

  patches = [
    ./pkg_config_additions.patch
    ./dont_clobber_environment.patch
  ];

  enableParallelBuilding = true;

  buildPhase = ''
    scons platform=x11 prefix=$out -j $NIX_BUILD_CORES \
      ${lib.concatStringsSep " "
          (lib.mapAttrsToList (k: v: "${k}=${builtins.toJSON v}") options)}
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp bin/godot.x11.tools.* $out/bin/godot
  '';

  meta = {
    homepage    = "https://godotengine.org";
    description = "Free and Open Source 2D and 3D game engine";
    license     = stdenv.lib.licenses.mit;
    platforms   = [ "i686-linux" "x86_64-linux" ];
    maintainers = [ stdenv.lib.maintainers.twey ];
  };
}
