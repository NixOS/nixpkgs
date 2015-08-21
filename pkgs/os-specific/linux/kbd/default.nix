{ stdenv, fetchurl, autoreconfHook, gzip, bzip2, pkgconfig, check, pam }:

stdenv.mkDerivation rec {
  name = "kbd-2.0.3";

  src = fetchurl {
    url = "mirror://kernel/linux/utils/kbd/${name}.tar.xz";
    sha256 = "0ppv953gn2zylcagr4z6zg5y2x93dxrml29plypg6xgbq3hrv2bs";
  };

  /* Get the dvorak programmer keymap (present in X but not in kbd) */
  dvpSrc = fetchurl {
    url = "http://kaufmann.no/downloads/linux/dvp-1_2_1.map.gz";
    sha256 = "0e859211cfe16a18a3b9cbf2ca3e280a23a79b4e40b60d8d01d0fde7336b6d50";
  };

  neoSrc = fetchurl {
    name = "neo.map";
    url = "https://svn.neo-layout.org/linux/console/neo.map?r=2455";
    sha256 = "1wlgp09wq84hml60hi4ls6d4zna7vhycyg40iipyh1279i91hsx7";
  };

  configureFlags = [
    "--enable-optional-progs"
    "--enable-libkeymap"
    "--disable-nls"
  ];

  patches = [ ./console-fix.patch ];

  postPatch =
    ''
      mkdir -p data/keymaps/i386/neo
      cat "$neoSrc" > data/keymaps/i386/neo/neo.map
      sed -i -e 's,^KEYMAPSUBDIRS *= *,&i386/neo ,' data/Makefile.am

      # Add the dvp keyboard in the dvorak folder
      ${gzip}/bin/gzip -c -d ${dvpSrc} > data/keymaps/i386/dvorak/dvp.map

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

  buildInputs = [ autoreconfHook pkgconfig check pam ];

  makeFlags = "setowner= ";

  meta = {
    homepage = ftp://ftp.altlinux.org/pub/people/legion/kbd/;
    description = "Linux keyboard utilities and keyboard maps";
    platforms = stdenv.lib.platforms.linux;
  };
}
