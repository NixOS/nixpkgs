{ stdenv, fetchurl, autoreconfHook, gzip, bzip2, pkgconfig, flex, check, pam }:

stdenv.mkDerivation rec {
  name = "kbd-${version}";
  version = "2.0.3";

  src = fetchurl {
    url = "mirror://kernel/linux/utils/kbd/${name}.tar.xz";
    sha256 = "0ppv953gn2zylcagr4z6zg5y2x93dxrml29plypg6xgbq3hrv2bs";
  };

  configureFlags = [
    "--enable-optional-progs"
    "--enable-libkeymap"
    "--disable-nls"
  ];

  patches = [ ./console-fix.patch ./search-paths.patch ];

  postPatch =
    ''
      # Add Neo keymap subdirectory
      sed -i -e 's,^KEYMAPSUBDIRS *= *,&i386/neo ,' data/Makefile.am

      # Fix the path to gzip/bzip2.
      substituteInPlace src/libkeymap/findfile.c \
        --replace gzip ${gzip}/bin/gzip \
        --replace bzip2 ${bzip2.bin}/bin/bzip2 \

      # We get a warning in armv5tel-linux and the fuloong2f, so we
      # disable -Werror in it.
      ${stdenv.lib.optionalString (stdenv.isArm || stdenv.system == "mips64el-linux") ''
        sed -i s/-Werror// src/Makefile.am
      ''}
    '';

  buildInputs = [ check pam ];
  nativeBuildInputs = [ autoreconfHook pkgconfig flex ];

  makeFlags = [ "setowner=" ];

  meta = with stdenv.lib; {
    homepage = ftp://ftp.altlinux.org/pub/people/legion/kbd/;
    description = "Linux keyboard utilities and keyboard maps";
    platforms = platforms.linux;
    license = licenses.gpl2Plus;
  };
}
