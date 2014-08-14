{stdenv, fetchurl, x11, zlib, libjpeg, imake, gccmakedep, libXmu, libXaw, libXpm, libXp , perl, xauth, fontDirectories}:

stdenv.mkDerivation {
  name = "tightvnc-1.3.10";

  src = fetchurl {
    url = mirror://sourceforge/vnc-tight/tightvnc-1.3.10_unixsrc.tar.bz2;
    sha256 = "f48c70fea08d03744ae18df6b1499976362f16934eda3275cead87baad585c0d";
  };

  # for the builder script
  inherit xauth fontDirectories perl;
  gcc = stdenv.gcc.gcc;

  buildInputs = [x11 zlib libjpeg imake gccmakedep libXmu libXaw libXpm libXp xauth];
  builder = ./builder.sh;

  meta = {
    license = stdenv.lib.licenses.gpl2Plus;
    homepage = "http://vnc-tight.sourceforge.net/";
    description = "TightVNC is an improved version of VNC";

    longDescription = ''
      TightVNC is an improved version of VNC, the great free
      remote-desktop tool. The improvements include bandwidth-friendly
      "tight" encoding, file transfers in the Windows version, enhanced
      GUI, many bugfixes, and more.
    '';

    maintainers = [];
    platforms = stdenv.lib.platforms.unix;
  };
}
