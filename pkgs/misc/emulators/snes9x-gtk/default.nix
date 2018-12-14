{ stdenv, fetchFromGitHub, autoreconfHook, wrapGAppsHook, intltool, pkgconfig
, SDL2, zlib, gtk3, libxml2, libXv, epoxy, minizip, portaudio }:

stdenv.mkDerivation rec {
  name = "snes9x-gtk-${version}";
  version = "1.57";

  src = fetchFromGitHub {
    owner = "snes9xgit";
    repo = "snes9x";
    rev = version;
    sha256 = "1jcvj2l03b98iz6aq4x747vfz7i6h6j339z4brj4vz71s11vn31a";
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
