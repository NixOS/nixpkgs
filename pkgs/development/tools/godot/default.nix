{ stdenv, fetchFromGitHub, gcc5, scons, pkgconfig, libX11, libXcursor
, libXinerama, libXrandr, libXrender, freetype, openssl, alsaLib
, libpulseaudio, libGLU, zlib }:

stdenv.mkDerivation rec {
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
    freetype openssl alsaLib libpulseaudio libGLU zlib
  ];

  patches = [ ./pkg_config_additions.patch ];

  enableParallelBuilding = true;

  buildPhase = ''
    # Disable touch because it's complaining about missing Xge.h during compilation.
    scons platform=x11 touch=false prefix=$out -j $NIX_BUILD_CORES
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
