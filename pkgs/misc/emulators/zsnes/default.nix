{stdenv, fetchurl, nasm, SDL, zlib, libpng, ncurses, mesa}:

stdenv.mkDerivation {
  name = "zsnes-1.51";

  src = fetchurl {
    url = mirror://sourceforge/zsnes/zsnes151src.tar.bz2;
    sha256 = "08s64qsxziv538vmfv38fg1rfrz5k95dss5zdkbfxsbjlbdxwmi8";
  };

  # copied from arch linux, fixes gcc-4.8 compatibility
  patches = [ ./zsnes.patch ];

  postPatch = ''
    patch -p0 < ${./zsnes-1.51-libpng15.patch}
  '';

  preConfigure = ''
    cd src
  '';

  buildInputs = [ nasm SDL zlib libpng ncurses mesa ];

  configureFlags = "--enable-release";

  meta = {
    description = "A Super Nintendo Entertainment System Emulator";
    license = "GPLv2+";
    maintainers = [ stdenv.lib.maintainers.sander ];
    homepage = http://www.zsnes.com;
  };
}