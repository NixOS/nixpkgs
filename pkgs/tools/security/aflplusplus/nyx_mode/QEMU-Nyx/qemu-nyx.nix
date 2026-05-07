{
  stdenv,
  lib,
  fetchFromGitHub,
  python3,
  pkg-config,
  flex,
  bison,
  glib,
  pixman,
  aflplusplus,
}:

# this derivation assumes x86_64-linux
assert stdenv.targetPlatform.system == "x86_64-linux";

stdenv.mkDerivation {
  version = builtins.readFile (aflplusplus.src + "/nyx_mode/QEMU_NYX_VERSION");
  pname = "QEMU-Nyx";

  src = aflplusplus.src;
  postUnpack = ''
    sourceRoot="$sourceRoot/nyx_mode/QEMU-Nyx"
  '';

  # same flags for ./configure as ./compile_qemu_nyx.sh static would set
  configureFlags = [
    "--target-list=x86_64-softmmu"
    "--disable-docs"
    "--disable-gtk"
    "--disable-werror"
    "--disable-capstone"
    "--disable-libssh"
    "--disable-tools"
    "--enable-nyx"
    "--enable-nyx-static"
  ];

  nativeBuildInputs = [
    python3
    pkg-config
    flex
    bison
  ];

  buildInputs = [
    glib
    pixman
  ];

  enableParallelBuilding = true;

  preConfigure = ''
    CAPSTONE_ROOT=$PWD/capstone_v4
    LIBXDC_ROOT=$PWD/libxdc

    make -C $CAPSTONE_ROOT -j$(nproc)
    make -C $LIBXDC_ROOT -j$(nproc) clean

    # For some reason the Makefile of libxdc clears LDFLAGS; we remove that line
    # so ld can find libcapstone.so.4
    sed -i '3d' $LIBXDC_ROOT/Makefile

    NO_LTO=1 LDFLAGS="-L$CAPSTONE_ROOT -L$LIBXDC_ROOT" CFLAGS="-I$CAPSTONE_ROOT/include/" make -C $LIBXDC_ROOT -j$(nproc)

    export LIBS="-L$CAPSTONE_ROOT -L$LIBXDC_ROOT/"
    export QEMU_CFLAGS="-I$CAPSTONE_ROOT/include/ -I$LIBXDC_ROOT/ $QEMU_CFLAGS"
  '';

  meta = {
    homepage = "https://github.com/nyx-fuzz/QEMU-Nyx";
    description = "Nyx's fork of QEMU";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.x86_64;
    maintainers = with lib.maintainers; [ ekzyis ];
  };
}
