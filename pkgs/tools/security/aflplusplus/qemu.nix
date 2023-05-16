<<<<<<< HEAD
{ lib
, stdenv
, python3
, zlib
, pkg-config
, glib
, perl
, texinfo
, libuuid
, flex
, bison
, pixman
, meson
, fetchFromGitHub
, ninja
}:

let
  qemuName = "qemu-5.2.50";
=======
{ lib, stdenv, fetchurl, aflplusplus, python3, zlib, pkg-config, glib, perl
, texinfo, libuuid, flex, bison, pixman, autoconf
}:

let
  qemuName = "qemu-3.1.0";
  cpuTarget = if stdenv.targetPlatform.system == "x86_64-linux" then "x86_64-linux-user"
    else if stdenv.targetPlatform.system == "i686-linux" then "i386-linux-user"
    else throw "aflplusplus: no support for ${stdenv.targetPlatform.system}!";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
in
stdenv.mkDerivation {
  name = "aflplusplus-${qemuName}";

<<<<<<< HEAD
  src = fetchFromGitHub {
    owner = "AFLplusplus";
    repo = "qemuafl";
    rev = "0569eff8a12dec73642b96757f6b5b51a618a03a";
    sha256 = "sha256-nYWHyRfOH2p9znRxjxsiyw11uZuMBiuJfEc7FHM5X7M=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    python3
    perl
    pkg-config
    flex
    bison
    meson
    texinfo
    ninja
  ];

  buildInputs = [
    zlib
    glib
    pixman
    libuuid
=======
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
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  enableParallelBuilding = true;

<<<<<<< HEAD
  dontUseMesonConfigure = true; # meson's configurePhase isn't compatible with qemu build
  preBuild = "cd build";
  preConfigure = ''
    # this script isn't marked as executable b/c it's indirectly used by meson. Needed to patch its shebang
    chmod +x ./scripts/shaderinclude.pl
    patchShebangs .
  '';

  configureFlags =
    [
      "--target-list=${stdenv.hostPlatform.uname.processor}-linux-user"
      "--sysconfdir=/etc"
      "--localstatedir=/var"
      "--meson=meson"
      "--disable-system"
      "--enable-linux-user"
      "--enable-pie"
      "--audio-drv-list="
      "--disable-blobs"
      "--disable-bochs"
      "--disable-brlapi"
      "--disable-bsd-user"
      "--disable-bzip2"
      "--disable-cap-ng"
      "--disable-cloop"
      "--disable-curl"
      "--disable-curses"
      "--disable-dmg"
      "--disable-fdt"
      "--disable-gcrypt"
      "--disable-glusterfs"
      "--disable-gnutls"
      "--disable-gtk"
      "--disable-guest-agent"
      "--disable-iconv"
      "--disable-libiscsi"
      "--disable-libnfs"
      "--disable-libssh"
      "--disable-libusb"
      "--disable-linux-aio"
      "--disable-live-block-migration"
      "--disable-lzo"
      "--disable-nettle"
      "--disable-numa"
      "--disable-opengl"
      "--disable-parallels"
      "--disable-plugins"
      "--disable-qcow1"
      "--disable-qed"
      "--disable-rbd"
      "--disable-rdma"
      "--disable-replication"
      "--disable-sdl"
      "--disable-seccomp"
      "--disable-sheepdog"
      "--disable-smartcard"
      "--disable-snappy"
      "--disable-spice"
      "--disable-system"
      "--disable-tools"
      "--disable-tpm"
      "--disable-usb-redir"
      "--disable-vde"
      "--disable-vdi"
      "--disable-vhost-crypto"
      "--disable-vhost-kernel"
      "--disable-vhost-net"
      "--disable-vhost-scsi"
      "--disable-vhost-user"
      "--disable-vhost-vdpa"
      "--disable-vhost-vsock"
      "--disable-virglrenderer"
      "--disable-virtfs"
      "--disable-vnc"
      "--disable-vnc-jpeg"
      "--disable-vnc-png"
      "--disable-vnc-sasl"
      "--disable-vte"
      "--disable-vvfat"
      "--disable-xen"
      "--disable-xen-pci-passthrough"
      "--disable-xfsctl"
      "--without-default-devices"
    ];

  meta = with lib; {
    homepage = "https://github.com/AFLplusplus/qemuafl";
=======
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
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    description = "Fork of QEMU with AFL++ instrumentation support";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ ris ];
    platforms = platforms.linux;
  };
}
