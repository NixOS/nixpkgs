{ stdenv, fetchurl, python, zlib, pkgconfig, glib, ncurses, perl
, attr, libcap, vde2, alsaLib, texinfo, libuuid, flex, bison, lzo, snappy
, libaio, libcap_ng, gnutls, pixman, autoconf
, writeText
}:

with stdenv.lib;

let
  n = "qemu-2.2.0";

  aflHeaderFile = writeText "afl-qemu-cpu-inl.h"
    (builtins.readFile ./qemu-patches/afl-qemu-cpu-inl.h);
  aflConfigFile = writeText "afl-config.h"
    (builtins.readFile ./qemu-patches/afl-config.h);
  aflTypesFile = writeText "afl-types.h"
    (builtins.readFile ./qemu-patches/afl-types.h);

  cpuTarget = if stdenv.system == "x86_64-linux" then "x86_64-linux-user"
    else if stdenv.system == "i686-linux" then "i386-linux-user"
    else throw "afl: no support for ${stdenv.system}!";
in
stdenv.mkDerivation rec {
  name = "afl-${n}";

  src = fetchurl {
    url = "http://wiki.qemu.org/download/${n}.tar.bz2";
    sha256 = "1703c3scl5n07gmpilg7g2xzyxnr7jczxgx6nn4m8kv9gin9p35n";
  };

  buildInputs =
    [ python zlib pkgconfig glib pixman ncurses perl attr libcap
      vde2 texinfo libuuid flex bison lzo snappy autoconf
      libcap_ng gnutls
    ]
    ++ optionals (hasSuffix "linux" stdenv.system) [ libaio ];

  enableParallelBuilding = true;

  patches =
    [ ./qemu-patches/elfload.patch
      ./qemu-patches/cpu-exec.patch
      ./qemu-patches/no-etc-install.patch
      ./qemu-patches/translate-all.patch
      ./qemu-patches/syscall.patch
    ];

  preConfigure = ''
    cp ${aflTypesFile}  afl-types.h
    cp ${aflConfigFile} afl-config.h
    cp ${aflHeaderFile} afl-qemu-cpu-inl.h
  '';

  configureFlags =
    [ "--disable-system"
      "--enable-linux-user"
      "--enable-guest-base"
      "--disable-gtk"
      "--disable-sdl"
      "--disable-vnc"
      "--target-list=${cpuTarget}"
      "--sysconfdir=/etc"
      "--localstatedir=/var"
    ];

  meta = with stdenv.lib; {
    homepage = http://www.qemu.org/;
    description = "Fork of QEMU with American Fuzzy Lop instrumentation support";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ thoughtpolice ];
    platforms = platforms.linux;
  };
}
