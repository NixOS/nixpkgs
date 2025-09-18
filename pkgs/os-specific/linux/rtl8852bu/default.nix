{
  lib,
  stdenv,
  fetchFromGitHub,
  kernel,
  bc,
  nukeReferences,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rtl8852bu";
  version = "${kernel.version}-unstable-2025-05-18";

  src = fetchFromGitHub {
    owner = "morrownr";
    repo = "rtl8852bu-20240418";
    rev = "1ef537712a55400aad637f53e45b60ed5ee621d7";
    hash = "sha256-8bO82ytorBYgIT0dNKRocOhiCrUhya7DkkMlJ1XM3Hk=";
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
    homepage = "https://github.com/morrownr/rtl8852bu-20240418";
    license = lib.licenses.gpl2Only;
    platforms = [ "x86_64-linux" ];
    broken = kernel.kernelOlder "6" && kernel.isHardened; # Similar to 79c1cf6
    maintainers = with lib.maintainers; [
      lonyelon
      thtrf
    ];
  };
})
