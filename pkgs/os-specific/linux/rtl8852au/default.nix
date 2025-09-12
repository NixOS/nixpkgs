{
  lib,
  stdenv,
  fetchFromGitHub,
  kernel,
  bc,
  nukeReferences,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rtl8852au";
  version = "${kernel.version}-unstable-2024-05-06";

  src = fetchFromGitHub {
    owner = "lwfinger";
    repo = "rtl8852au";
    rev = "865ab0fa91471d595c283d2f3db323f7f15455f5";
    hash = "sha256-c2dpnZS6a0waL1khB9ZEglTwJIBsyRebTMig1B4A0xU=";
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
    # https://github.com/lwfinger/rtl8852au/pull/115
    ./fix-build-for-kernels-6.13-6.14.patch
  ];

  postPatch = ''
    substituteInPlace ./Makefile \
      --replace-fail /sbin/depmod \# \
      --replace-fail '$(MODDESTDIR)' "$out/lib/modules/${kernel.modDirVersion}/kernel/net/wireless/" \
      --replace-fail '/usr/lib/systemd/system-sleep' "$out/usr/lib/systemd/system-sleep"
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

  # GCC 14 makes this an error by default
  env.NIX_CFLAGS_COMPILE = "-Wno-designated-init";

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Driver for Realtek 802.11ac, rtl8852au, provides the 8852au mod";
    homepage = "https://github.com/lwfinger/rtl8852au";
    license = licenses.gpl2Only;
    platforms = [ "x86_64-linux" ];
    # FIX: error: invalid initializer
    broken = kernel.kernelOlder "6" && kernel.isHardened;
    maintainers = with maintainers; [ lonyelon ];
  };
})
