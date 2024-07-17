{
  lib,
  stdenv,
  fetchFromGitHub,
  kernel,
  bc,
  nukeReferences,
}:

stdenv.mkDerivation {
  pname = "rtl8852bu";
  version = "${kernel.version}-unstable-2024-03-28";

  src = fetchFromGitHub {
    owner = "morrownr";
    repo = "rtl8852bu";
    rev = "f6aaa3c0094c541d9b0347926c76c1e9cc4a49d1";
    hash = "sha256-Jbd6nixo873LU74klhhQU1qD3ahxEnywdqcF89LTRxc=";
  };

  nativeBuildInputs = [
    bc
    nukeReferences
  ] ++ kernel.moduleBuildDependencies;
  hardeningDisable = [
    "pic"
    "format"
  ];

  postPatch = ''
    substituteInPlace ./Makefile \
      --replace-fail /sbin/depmod \# \
      --replace-fail '$(MODDESTDIR)' "$out/lib/modules/${kernel.modDirVersion}/kernel/net/wireless/"
    substituteInPlace ./platform/i386_pc.mk \
      --replace-fail /lib/modules "${kernel.dev}/lib/modules"
  '';

  makeFlags =
    [
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

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Driver for Realtek rtl8852au and rtl8832bu chipsets, provides the 8852au mod";
    homepage = "https://github.com/morrownr/rtl8852bu";
    license = licenses.gpl2Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ lonyelon ];
  };
}
