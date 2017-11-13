{ stdenv, fetchFromGitHub, gcc, scons, pkgconfig, libX11, libXcursor
, libXinerama, libXrandr, libXrender, freetype, openssl, alsaLib
, libpulseaudio, mesa_glu, zlib }:

stdenv.mkDerivation rec {
  name    = "godot-${version}";
  version = "2.1.4-stable";

  src = fetchFromGitHub {
    owner  = "godotengine";
    repo   = "godot";
    rev    = version;
    sha256 = "0d2zczn5k7296sky5gllq55cxd586nx134y2iwjpkqqjr62g0h48";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    gcc scons libX11 libXcursor libXinerama libXrandr libXrender
    freetype openssl alsaLib libpulseaudio mesa_glu zlib
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
