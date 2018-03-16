{ stdenv, lib, fetchFromGitHub, gcc5, scons, pkgconfig, libX11, libXcursor
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
  version = "3.0";

  src = fetchFromGitHub {
    owner  = "godotengine";
    repo   = "godot";
    rev    = "${version}-stable";
    sha256 = "1pgs2hghjhs3vkgxsi50i5myr7yac3jhpk4vi4bcra1cvdmkgr39";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    gcc5 scons libX11 libXcursor libXinerama libXrandr libXrender
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
    cp -r bin/godot.x11.tools.64 $out/bin/godot
  '';

  meta = {
    homepage    = "https://godotengine.org";
    description = "Free and Open Source 2D and 3D game engine";
    license     = stdenv.lib.licenses.mit;
    platforms   = [ "i646-linux" "x86_64-linux" ];
    maintainers = [ stdenv.lib.maintainers.twey ];
  };
}
