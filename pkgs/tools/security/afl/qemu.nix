{ lib, stdenv, fetchurl, afl, python2, zlib, pkg-config, glib, perl
, texinfo, libuuid, flex, bison, pixman, autoconf
}:

let
  cpuTarget = if stdenv.hostPlatform.system == "x86_64-linux" then "x86_64-linux-user"
    else if stdenv.hostPlatform.system == "i686-linux" then "i386-linux-user"
    else throw "afl: no support for ${stdenv.hostPlatform.system}!";
in
stdenv.mkDerivation rec {
  pname = "afl-qemu";
  version = "2.10.0";

  srcs = [
    (fetchurl {
      url = "http://wiki.qemu.org/download/qemu-${version}.tar.bz2";
      sha256 = "0j3dfxzrzdp1w21k21fjvmakzc6lcha1rsclaicwqvbf63hkk7vy";
    })
    afl.src
  ];

  sourceRoot = "qemu-${version}";

  postUnpack = ''
    cp ${afl.src.name}/types.h $sourceRoot/afl-types.h
    substitute ${afl.src.name}/config.h $sourceRoot/afl-config.h \
      --replace "types.h" "afl-types.h"
    substitute ${afl.src.name}/qemu_mode/patches/afl-qemu-cpu-inl.h $sourceRoot/afl-qemu-cpu-inl.h \
      --replace "../../config.h" "afl-config.h"
    substituteInPlace ${afl.src.name}/qemu_mode/patches/cpu-exec.diff \
      --replace "../patches/afl-qemu-cpu-inl.h" "afl-qemu-cpu-inl.h"
  '';

  nativeBuildInputs = [
    python2 perl pkg-config flex bison autoconf texinfo
  ];

  buildInputs = [
    zlib glib pixman libuuid
  ];

  enableParallelBuilding = true;

  patches = [
    # patches extracted from afl source
    "../${afl.src.name}/qemu_mode/patches/cpu-exec.diff"
    "../${afl.src.name}/qemu_mode/patches/elfload.diff"
    "../${afl.src.name}/qemu_mode/patches/syscall.diff"
    "../${afl.src.name}/qemu_mode/patches/configure.diff"
    "../${afl.src.name}/qemu_mode/patches/memfd.diff"
    # nix-specific patches to make installation more well-behaved
    ./qemu-patches/no-etc-install.patch
    # patch for fixing qemu build on glibc >= 2.30
    ./qemu-patches/syscall-glibc2_30.diff
  ];

  configureFlags =
    [ "--disable-system"
      "--enable-linux-user"
      "--disable-gtk"
      "--disable-sdl"
      "--disable-vnc"
      "--disable-kvm"
      "--target-list=${cpuTarget}"
      "--enable-pie"
      "--sysconfdir=/etc"
      "--localstatedir=/var"
    ];

  meta = with lib; {
    homepage = "http://www.qemu.org/";
    description = "Fork of QEMU with AFL instrumentation support";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ thoughtpolice ];
    platforms = platforms.linux;
  };
}
