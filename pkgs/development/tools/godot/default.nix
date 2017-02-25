{ stdenv, fetchFromGitHub, gcc, scons, pkgconfig, libX11, libXcursor
, libXinerama, libXrandr, libXrender, freetype, openssl, alsaLib
, libpulseaudio, mesa, mesa_glu, zlib }:

stdenv.mkDerivation rec {
  name    = "godot-${version}";
  version = "2.1.1-stable";

  src = fetchFromGitHub {
    owner  = "godotengine";
    repo   = "godot";
    rev    = version;
    sha256 = "071qkm1l6yn2s9ha67y15w2phvy5m5wl3wqvrslhfmnsir3q3k01";
  };

  buildInputs = [
    gcc scons pkgconfig libX11 libXcursor libXinerama libXrandr libXrender
    freetype openssl alsaLib libpulseaudio mesa mesa_glu zlib
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
    homepage    = "http://godotengine.org";
    description = "Free and Open Source 2D and 3D game engine";
    license     = stdenv.lib.licenses.mit;
    platforms   = stdenv.lib.platforms.linux;
  };
}
