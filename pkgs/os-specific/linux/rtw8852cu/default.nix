{
  lib,
  stdenv,
  fetchFromGitHub,
  kernel,
  bc,
  nukeReferences,
}:
stdenv.mkDerivation rec {
  pname = "rtw8852cu";
  version = "${kernel.version}-unstable-2024-04-28";

  src = fetchFromGitHub {
    owner = "lwfinger";
    repo = pname;
    rev = "d256c2ae282b70f03629e36900da54905ab4187c";
    hash = "sha256-RHKoy/XMANF7Ma7ZxLhzpTJR3NEQUSQBH/hOLwnvvNg=";
  };

  nativeBuildInputs = [
    bc
    nukeReferences
  ] ++ kernel.moduleBuildDependencies;

  hardeningDisable = [
    "pic"
    "format"
  ];

  patches = [
    ./txe70uh.patch
    ./0001-add-platforms_ops-to-arm_rk-HCI_USB.patch
  ];

  KVER = kernel.version;

  postPatch = ''
    substituteInPlace ./Makefile \
      --replace-fail /sbin/depmod \# \
      --replace-fail '$(MODDESTDIR)' "$out/lib/modules/${kernel.modDirVersion}/kernel/net/wireless/"

    substituteInPlace ./platform/i386_pc.mk \
      --replace-fail /lib/modules "${kernel.dev}/lib/modules"

    substituteInPlace ./platform/arm_rk.mk --replace-fail \
      /home/android_sdk/Rockchip/Rk3188/kernel "${kernel.dev}/lib/modules/''${KVER}/build" \
      --replace-fail \
      /home/android_sdk/Rockchip/Rk3188/prebuilts/gcc/linux-x86/arm/arm-eabi-4.6/bin/arm-eabi- ""
  '';

  makeFlags =
    [
      "ARCH=${stdenv.hostPlatform.linuxArch}"
      ("CONFIG_PLATFORM_I386_PC=" + (if stdenv.hostPlatform.isx86 then "y" else "n"))
      ("CONFIG_PLATFORM_ARM_ROCKCHIP=" + (if stdenv.hostPlatform.isAarch then "y" else "n"))
    ]
    ++ lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
      "CROSS_COMPILE=${stdenv.cc.targetPrefix}"
    ];

  preInstall = ''
    mkdir -p "$out/lib/modules/${kernel.modDirVersion}/kernel/net/wireless/"
  '';

  postInstall = ''
    nuke-refs $out/lib/modules/*/kernel/net/wireless/*.ko
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Driver for Realtek rtl8852cu and rtl8832cu chipsets, provides the 8852cu mod";
    homepage = "https://github.com/lwfinger/rtl8852cu";
    license = licenses.gpl2Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ matdibu ];
  };
}
