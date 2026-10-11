{
  lib,
  stdenv,
  fetchFromGitHub,
  kernel,
  bc,
  nukeReferences,
}:
stdenv.mkDerivation (finalAttrs: {
  # Use of the rtl8852bu and rlt8832bu drivers should no longer be required in Linux kernel version '7.2' and greater.
  #
  # See: https://github.com/morrownr/rtl8852bu-20250826/blob/b6a299b4fe95cb6a37eec27a6c3b21cbaa6abfa8/README.md?plain=1#L25
  pname = "rtl8852bu";
  version = "${kernel.version}-unstable-2026-10-10";

  src = fetchFromGitHub {
    owner = "morrownr";
    repo = "rtl8852bu-20250826";
    rev = "b6a299b4fe95cb6a37eec27a6c3b21cbaa6abfa8";
    hash = "sha256-QgVDm7G3iVwNhRIfK+fLpx2P44XjX3Dny4cYFex5l70=";
  };

  nativeBuildInputs = [
    bc
    nukeReferences
  ]
  ++ kernel.moduleBuildDependencies;
  hardeningDisable = [
    "pic"
    "format"
  ];

  patches = [
    ./support-linux-kernel-versions-6.1-6.7.patch
  ];

  postPatch = ''
    substituteInPlace ./Makefile \
      --replace-fail /sbin/depmod \# \
      --replace-fail '$(MODDESTDIR)' "$out/lib/modules/${kernel.modDirVersion}/kernel/net/wireless/" \
      --replace-fail 'cp -f $(MODULE_NAME).conf /etc/modprobe.d' \
      'mkdir -p $out/etc/modprobe.d && cp -f $(MODULE_NAME).conf $out/etc/modprobe.d' \
      --replace-fail "sh edit-options.sh" ""
    substituteInPlace ./platform/i386_pc.mk \
      --replace-fail /lib/modules "${kernel.dev}/lib/modules"
  '';

  makeFlags = [
    "ARCH=${stdenv.hostPlatform.linuxArch}"
    ("CONFIG_PLATFORM_I386_PC=" + (if stdenv.hostPlatform.isx86 then "y" else "n"))
    ("CONFIG_PLATFORM_ARM_RPI=" + (if stdenv.hostPlatform.isAarch then "y" else "n"))
  ]
  ++ lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
    "CROSS_COMPILE=${stdenv.cc.targetPrefix}"
  ];

  preInstall = ''
    mkdir -p "$out/lib/modules/${kernel.modDirVersion}/kernel/net/wireless/"
    mkdir -p "$out/usr/lib/systemd/system-sleep"
  '';

  postInstall = ''
    nuke-refs $out/lib/modules/*/kernel/net/wireless/*.ko
  '';

  env.NIX_CFLAGS_COMPILE = "-Wno-designated-init"; # Similar to 79c1cf6

  enableParallelBuilding = true;

  meta = {
    description = "Driver for Realtek rtl8852bu and rtl8832bu chipsets, provides the 8852bu mod";
    homepage = "https://github.com/morrownr/rtl8852bu-20250826";
    license = lib.licenses.gpl2Only;
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [
      lonyelon
      thtrf
    ];
  };
})
