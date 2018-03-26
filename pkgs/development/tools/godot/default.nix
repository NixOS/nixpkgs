{ stdenv, fetchFromGitHub, gcc5, scons, pkgconfig, libX11, libXcursor
, libXinerama, libXrandr, libXrender, libXi, libXext, libXfixes
, freetype, openssl, alsaLib, libpulseaudio, libGLU, zlib }:

stdenv.mkDerivation rec {
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
    gcc5 scons libX11 libXcursor libXinerama libXrandr libXrender
    libXi libXext libXfixes freetype openssl alsaLib libpulseaudio
    libGLU zlib
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
