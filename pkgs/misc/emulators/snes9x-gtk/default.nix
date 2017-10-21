{ stdenv, fetchFromGitHub, autoreconfHook, intltool, pkgconfig
, SDL, zlib, gtk2, libxml2, libXv }:

stdenv.mkDerivation rec {
  name = "snes9x-gtk-${version}";
  version = "1.54.1";

  src = fetchFromGitHub {
    owner = "snes9xgit";
    repo = "snes9x";
    rev = version;
    sha256 = "10fqm7lk36zj2gnx0ypps0nlws923f60b0zj4pmq9apawgx8k6rw";
  };

  nativeBuildInputs = [ autoreconfHook intltool pkgconfig ];

  sourceRoot = "snes9x-${version}-src";
  preAutoreconf = "cd gtk; intltoolize";  
    
  buildInputs = [ SDL zlib gtk2 libxml2 libXv ];
  installPhase = "install -Dt $out/bin snes9x-gtk";

  meta = with stdenv.lib; {
    description = "A portable, freeware Super Nintendo Entertainment System (SNES) emulator";
    longDescription = ''
      Snes9x is a portable, freeware Super Nintendo Entertainment System (SNES)
      emulator. It basically allows you to play most games designed for the SNES
      and Super Famicom Nintendo game systems on your PC or Workstation; which
      includes some real gems that were only ever released in Japan.
    '';
    license = licenses.lgpl2;
    maintainers = with maintainers; [ qknight ];
    homepage = http://www.snes9x.com/;
    platforms = platforms.linux;
  };
}
