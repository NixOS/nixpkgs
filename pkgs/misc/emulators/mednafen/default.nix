{ stdenv, fetchurl, pkgconfig, freeglut, libGLU_combined, libcdio, libjack2
, libsamplerate, libsndfile, libX11, SDL, SDL_net, zlib }:

stdenv.mkDerivation rec {
  name = "mednafen-${version}";
  version = "0.9.48";

  src = fetchurl {
    url = "https://mednafen.github.io/releases/files/${name}.tar.xz";
    sha256 = "00i12mywhp43274aq466fwavglk5b7d8z8bfdna12ra9iy1hrk6k";
  };

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [
    freeglut
    libGLU_combined
    libcdio
    libjack2
    libsamplerate
    libsndfile
    libX11
    SDL
    SDL_net
    zlib
  ];

  hardeningDisable = [ "pic" ];

  postInstall = ''
    mkdir -p $out/share/doc
    mv Documentation $out/share/doc/mednafen
  '';

  meta = with stdenv.lib; {
    description = "A portable, CLI-driven, SDL+OpenGL-based, multi-system emulator";
    homepage = https://mednafen.github.io/;
    license = licenses.gpl2;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = platforms.linux;
  };
}
