{ stdenv, fetchurl, gzip, bzip2 }:

stdenv.mkDerivation rec {
  name = "kbd-1.15.3";

  src = fetchurl {
    url = "ftp://ftp.altlinux.org/pub/people/legion/kbd/${name}.tar.gz";
    sha256 = "1vcl2791xshjdpi4w88iy87gkb7zv0dbvi83f98v30dvqc9mfl46";
  };

  configureFlags = "--disable-nls";  

  patchPhase =
    ''
      # Fix the path to gzip/bzip2.
      substituteInPlace src/findfile.c \
        --replace gzip ${gzip}/bin/gzip \
        --replace bzip2 ${bzip2}/bin/bzip2 \
    
      # We get a warning in armv5tel-linux and the fuloong2f, so we
      # disable -Werror in it.
      ${stdenv.lib.optionalString (stdenv.isArm || stdenv.system == "mips64el-linux") ''
        sed -i s/-Werror// src/Makefile.am
      ''}
    '';

  makeFlags = "setowner= ";

  meta = {
    homepage = ftp://ftp.altlinux.org/pub/people/legion/kbd/;
    description = "Linux keyboard utilities and keyboard maps";
  };
}
