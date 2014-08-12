{stdenv, fetchurl, nasm, SDL, zlib, libpng, ncurses, mesa, intltool, gtk, pkgconfig, libxml2, x11, pulseaudio}:

stdenv.mkDerivation rec {
  name = "snes9x-gtk-${version}";
  version = "1.53";

  src = fetchurl {
    url = "http://files.ipherswipsite.com/snes9x/snes9x-${version}-src.tar.bz2";
    sha256 = "9f7c5d2d0fa3fe753611cf94e8879b73b8bb3c0eab97cdbcb6ab7376efa78dc3";
  };

  buildInputs = [ nasm SDL zlib libpng ncurses mesa intltool gtk pkgconfig libxml2 x11 pulseaudio];

  sourceRoot = "snes9x-${version}-src/gtk";

  configureFlags = "--prefix=$out/ --with-opengl";

  installPhase = ''
    mkdir -p $out/bin
    cp snes9x-gtk $out/bin
  '';

  meta = {
    description = "a portable, freeware Super Nintendo Entertainment System (SNES) emulator";
    longDescription = "Snes9x is a portable, freeware Super Nintendo Entertainment System (SNES) emulator. It basically allows you to play most games designed for the SNES and Super Famicom Nintendo game systems on your PC or Workstation; which includes some real gems that were only ever released in Japan.";
    license = stdenv.lib.licenses.lgpl2;
    maintainers = [ stdenv.lib.maintainers.qknight ];
    homepage = http://www.snes9x.com/;
  };
}
