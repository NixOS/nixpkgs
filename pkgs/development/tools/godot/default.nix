{ stdenv, fetchFromGitHub, gcc5, scons, pkgconfig, libX11, libXcursor
, libXinerama, libXrandr, libXrender, freetype, openssl, alsaLib
, libpulseaudio, libGLU, zlib }:

stdenv.mkDerivation rec {
  name    = "godot-${version}";
  version = "2.1.4";

  src = fetchFromGitHub {
    owner  = "godotengine";
    repo   = "godot";
    rev    = "${version}-stable";
    sha256 = "0d2zczn5k7296sky5gllq55cxd586nx134y2iwjpkqqjr62g0h48";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    gcc5 scons libX11 libXcursor libXinerama libXrandr libXrender
    freetype openssl alsaLib libpulseaudio libGLU zlib
  ];

  patches = [ ./pkg_config_additions.patch ];

  enableParallelBuilding = true;

  buildPhase = ''
    scons platform=x11 prefix=$out -j $NIX_BUILD_CORES
  '';

  installPhase = ''
    mkdir $out/bin -p
    cp bin/godot.* $out/bin/
  '';

  meta = {
    homepage    = "https://godotengine.org";
    description = "Free and Open Source 2D and 3D game engine";
    license     = stdenv.lib.licenses.mit;
    platforms   = stdenv.lib.platforms.linux;
  };
}
