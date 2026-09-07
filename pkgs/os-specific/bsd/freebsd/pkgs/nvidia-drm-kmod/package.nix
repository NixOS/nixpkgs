{
  lib,
  stdenv,
  mkDerivation,
  fetchurl,
  fetchpatch,
  sys,
  drm-kmod,
  xargs-j,
  nvidia-driver,
}:
mkDerivation rec {
  path = "...";
  pname = "nvidia-drm-kmod";
  inherit (nvidia-driver) version src;

  outputs = [
    "out"
    "debug"
  ];

  patches =
    lib.optionals (lib.versionOlder version "565") [
      (fetchpatch {
        url = "https://raw.githubusercontent.com/freebsd/freebsd-ports/d07cdab9108a8cf6ab66aa1ff834339f8695f457/graphics/nvidia-drm-61-kmod/files/extra-patch-nvidia-drm-conftest.h";
        extraPrefix = "a/src/nvidia-drm";
        hash = "sha256-EgzEx1VxQyoNpnY0MnNVa08A0ENSyU/rdRM2hOwUE2g=";
      })
    ]
    ++ lib.optionals (lib.versionOlder version "555") [
      (fetchpatch {
        url = "https://raw.githubusercontent.com/freebsd/freebsd-ports/d07cdab9108a8cf6ab66aa1ff834339f8695f457/graphics/nvidia-drm-61-kmod/files/extra-patch-nvidia-drm-freebsd-lkpi.c";
        extraPrefix = "a/src/nvidia-drm";
        hash = "sha256-aFOs811J5e9Nu8Kwd6dImiSefEOlKlnRp3kg7DTIccg=";
      })
    ];

  postPatch =
    lib.optionalString (lib.versionAtLeast version "570") ''
      sed -E -i -e 's:\&nv_drm_fbdev_module_param\,  1\,:\&nv_drm_fbdev_module_param\,  0\,:' src/nvidia-drm/nvidia-drm-freebsd-lkpi.c
      sed -E -i -e 's:bool nv_drm_fbdev_module_param = true;:bool nv_drm_fbdev_module_param = false;:' src/nvidia-drm/nvidia-drm-os-interface.c
    ''
    + ''
      sed -E -i -e '/DRMKMODDIR.*\/linuxkpi\/dummy\/include/d' src/nvidia-drm/Makefile

      mkdir -p $TMP/bin
      ln -s ${stdenv.cc}/bin/${stdenv.cc.targetPrefix}nm $TMP/bin/nm
      export PATH=$PATH:$TMP/bin
    '';

  env.NIX_CFLAGS_COMPILE = "-Wno-error=implicit-function-declaration"; # conftests rely on this
  env.CONFTEST_BSD_KMODPATHS = "${sys}/kernel ${drm-kmod}/kernel";

  extraNativeBuildInputs = [
    xargs-j
  ];

  preConfigure = ''
    cd src/nvidia-drm
  '';

  makeFlags = [
    "BSDSRCTOP=${sys.src}"
    "SYSDIR=${sys.src}/sys"
    "DRMKMODDIR=${drm-kmod.src}"
    "NO_XREF=1"
    "DEBUG_FLAGS=-g"
  ];

  KMODDIR = "${builtins.placeholder "out"}/kernel";
  KERN_DEBUGDIR = "${builtins.placeholder "debug"}/lib/debug";
  KERN_DEBUGDIR_KODIR = "${KERN_DEBUGDIR}/kernel";
  KERN_DEBUGDIR_KMODDIR = "${KERN_DEBUGDIR}/kernel";

  hardeningDisable = [
    "pic" # generates relocations the linker can't handle
  ];

  meta.platforms = [ "x86_64-freebsd" ];
  meta.license = lib.licenses.unfree;
}
