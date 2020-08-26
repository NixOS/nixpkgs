{ stdenv, fetchFromGitHub, meson, ninja, pkgconfig, wrapGAppsHook
, SDL2, zlib, gtk3, libxml2, libXv, epoxy, minizip, pulseaudio, portaudio }:

stdenv.mkDerivation rec {
  pname = "snes9x-gtk";
  version = "1.60";

  src = fetchFromGitHub {
    owner = "snes9xgit";
    repo = "snes9x";
    rev = version;
    sha256 = "12hpn7zcdvp30ldpw2zf115yjqv55n1ldjbids7vx0lvbpr06dm1";
  };

  enableParallelBuilding = true;
  nativeBuildInputs = [ meson ninja pkgconfig wrapGAppsHook ];
  buildInputs = [ SDL2 zlib gtk3 libxml2 libXv epoxy minizip pulseaudio portaudio ];

  preConfigure = "cd gtk";

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
