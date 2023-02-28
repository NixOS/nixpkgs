{ lib, stdenv, fetchurl, aflplusplus, python3, zlib, pkg-config, glib, perl
, texinfo, libuuid, flex, bison, pixman, autoconf
}:

let
  qemuName = "qemu-3.1.0";
  cpuTarget = if stdenv.targetPlatform.system == "x86_64-linux" then "x86_64-linux-user"
    else if stdenv.targetPlatform.system == "i686-linux" then "i386-linux-user"
    else throw "aflplusplus: no support for ${stdenv.targetPlatform.system}!";
in
stdenv.mkDerivation {
  name = "aflplusplus-${qemuName}";

  srcs = [
    (fetchurl {
      url = "http://wiki.qemu.org/download/${qemuName}.tar.bz2";
      sha256 = "08frr1fdjx8qcfh3fafn10kibdwbvkqqvfl7hpqbm7i9dg4f1zlq";
    })
    aflplusplus.src
  ];

  sourceRoot = qemuName;

  postUnpack = ''
    chmod -R +w ${aflplusplus.src.name}
    for f in ${aflplusplus.src.name}/qemu_mode/patches/* ; do
      sed -E -i 's|(\.\./)+patches/([a-z-]+\.h)|\2|g' $f
      sed -E -i 's|\.\./\.\./config\.h|afl-config.h|g' $f
      sed -E -i 's|\.\./\.\./include/cmplog\.h|afl-cmplog.h|g' $f
    done
    cp ${aflplusplus.src.name}/qemu_mode/patches/*.h $sourceRoot/
    cp ${aflplusplus.src.name}/types.h $sourceRoot/afl-types.h
    substitute ${aflplusplus.src.name}/config.h $sourceRoot/afl-config.h \
      --replace "types.h" "afl-types.h"
    substitute ${aflplusplus.src.name}/include/cmplog.h $sourceRoot/afl-cmplog.h \
      --replace "config.h" "afl-config.h" \
      --replace "forkserver.h" "afl-forkserver.h"
    substitute ${aflplusplus.src.name}/include/forkserver.h $sourceRoot/afl-forkserver.h \
      --replace "types.h" "afl-types.h"

    cat ${aflplusplus.src.name}/qemu_mode/patches/*.diff > all.patch
  '';

  nativeBuildInputs = [
    python3 perl pkg-config flex bison autoconf texinfo
  ];

  buildInputs = [
    zlib glib pixman libuuid
  ];

  enableParallelBuilding = true;

  patches = [
    # patches extracted from aflplusplus source
    "../all.patch"
    # nix-specific patches to make installation more well-behaved
    ./qemu-no-etc-install.patch
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
    homepage = "https://www.qemu.org/";
    description = "Fork of QEMU with AFL++ instrumentation support";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ ris ];
    platforms = platforms.linux;
  };
}
