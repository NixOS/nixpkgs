{ stdenv, fetchurl, libpng, static ? false }:

# This package comes with its own copy of zlib, libpng and pngxtern

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "optipng-0.7.4";

  src = fetchurl {
    url = "mirror://sourceforge/optipng/${name}.tar.gz";
    sha256 = "1zrphbz17rhhfl1l95q5s979rrhifbwczl2xj1fdrnq5jid5s2sj";
  };

  buildInputs = [ libpng ];

  LDFLAGS = optional static "-static";
  configureFlags = "--with-system-zlib --with-system-libpng";

  crossAttrs = {
    CC="${stdenv.cross.config}-gcc";
    LD="${stdenv.cross.config}-gcc";
    AR="${stdenv.cross.config}-ar";
    RANLIB="${stdenv.cross.config}-ranlib";
    configurePhase = ''
      ./configure -prefix="$out" --with-system-zlib --with-system-libpng
    '';
    postInstall = optional (stdenv.cross.libc == "msvcrt") ''
      mv "$out"/bin/optipng "$out"/bin/optipng.exe
    '';
  };

  meta = {
    homepage = http://optipng.sourceforge.net/;
    description = "A PNG optimizer";
    license = "bsd";
  };
}
