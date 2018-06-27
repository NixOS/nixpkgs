{ stdenv, fetchFromGitHub, autoreconfHook, wrapGAppsHook, intltool, pkgconfig
, SDL2, zlib, gtk3, libxml2, libXv, epoxy, minizip, portaudio }:

stdenv.mkDerivation rec {
  name = "snes9x-gtk-${version}";
  version = "1.56.2";

  src = fetchFromGitHub {
    owner = "snes9xgit";
    repo = "snes9x";
    rev = version;
    sha256 = "0cbv95799gpagf6bxs1fmwmxvz5qs9g2rmmf5fsdd1cb4lryaijr";
  };

  enableParallelBuilding = true;
  nativeBuildInputs = [ autoreconfHook wrapGAppsHook intltool pkgconfig ];
  buildInputs = [ SDL2 zlib gtk3 libxml2 libXv epoxy minizip portaudio ];

  preAutoreconf = ''
    cd gtk
    intltoolize
  '';

  meta = with stdenv.lib; {
    homepage = "http://www.snes9x.com";
    description = "Super Nintendo Entertainment System (SNES) emulator";

    longDescription = ''
      Snes9x is a portable, freeware Super Nintendo Entertainment System (SNES)
      emulator. It basically allows you to play most games designed for the SNES
      and Super Famicom Nintendo game systems on your PC or Workstation; which
      includes some real gems that were only ever released in Japan.
    '';

    license = licenses.lgpl2;
    maintainers = with maintainers; [ qknight ];
    platforms = platforms.linux;
  };
}
