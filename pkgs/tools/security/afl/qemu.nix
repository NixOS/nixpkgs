{ stdenv, fetchurl, afl, python2, zlib, pkgconfig, glib, ncurses, perl
, attr, libcap, vde2, texinfo, libuuid, flex, bison, lzo, snappy
, libaio, libcap_ng, gnutls, pixman, autoconf
, writeText
}:

with stdenv.lib;

let
  qemuName = "qemu-2.10.0";
  aflName = afl.name;
  cpuTarget = if stdenv.hostPlatform.system == "x86_64-linux" then "x86_64-linux-user"
    else if stdenv.hostPlatform.system == "i686-linux" then "i386-linux-user"
    else throw "afl: no support for ${stdenv.hostPlatform.system}!";
in
stdenv.mkDerivation rec {
  name = "afl-${qemuName}";

  srcs = [
    (fetchurl {
      url = "http://wiki.qemu.org/download/${qemuName}.tar.bz2";
      sha256 = "0j3dfxzrzdp1w21k21fjvmakzc6lcha1rsclaicwqvbf63hkk7vy";
    })
    afl.src
  ];

  sourceRoot = qemuName;

  postUnpack = ''
    cp ${aflName}/types.h $sourceRoot/afl-types.h
    substitute ${aflName}/config.h $sourceRoot/afl-config.h \
      --replace "types.h" "afl-types.h"
    substitute ${aflName}/qemu_mode/patches/afl-qemu-cpu-inl.h $sourceRoot/afl-qemu-cpu-inl.h \
      --replace "../../config.h" "afl-config.h"
    substituteInPlace ${aflName}/qemu_mode/patches/cpu-exec.diff \
      --replace "../patches/afl-qemu-cpu-inl.h" "afl-qemu-cpu-inl.h"
  '';

  nativeBuildInputs = [
    python2 perl pkgconfig flex bison autoconf texinfo
  ];

  buildInputs = [
    zlib glib pixman ncurses attr libcap
    vde2 libuuid lzo snappy libcap_ng gnutls
  ] ++ optionals (stdenv.isLinux) [ libaio ];

  enableParallelBuilding = true;

  patches = [
    # patches extracted from afl source
    "../${aflName}/qemu_mode/patches/cpu-exec.diff"
    "../${aflName}/qemu_mode/patches/elfload.diff"
    "../${aflName}/qemu_mode/patches/syscall.diff"
    # nix-specific patches to make installation more well-behaved
    ./qemu-patches/no-etc-install.patch
    ./qemu-patches/qemu-2.10.0-glibc-2.27.patch
  ];

  configureFlags =
    [ "--disable-system"
      "--enable-linux-user"
      "--disable-gtk"
      "--disable-sdl"
      "--disable-vnc"
      "--target-list=${cpuTarget}"
      "--enable-pie"
      "--enable-kvm"
      "--sysconfdir=/etc"
      "--localstatedir=/var"
    ];

  meta = with stdenv.lib; {
    homepage = http://www.qemu.org/;
    description = "Fork of QEMU with AFL instrumentation support";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ thoughtpolice ];
    platforms = platforms.linux;
  };
}
