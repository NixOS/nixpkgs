{
  lib,
  stdenv,
  fetchFromGitHub,
  kernel,
  bc,
  nukeReferences,
}:

stdenv.mkDerivation {
  pname = "rtl8812au";
  version = "${kernel.version}-unstable-2024-03-20";

  src = fetchFromGitHub {
    owner = "morrownr";
    repo = "8812au-20210629";
    rev = "8be3a1d7acf60f77c5d9c33b690b8d7301bdf127";
    hash = "sha256-HchnRezJNzimOB72Sv5BwL4oXuxPxloAHVuaL+warj8=";
  };

  nativeBuildInputs = [
    bc
    nukeReferences
  ] ++ kernel.moduleBuildDependencies;
  hardeningDisable = [
    "pic"
    "format"
  ];

  prePatch = ''
    substituteInPlace ./Makefile \
      --replace /lib/modules/ "${kernel.dev}/lib/modules/" \
      --replace /sbin/depmod \# \
      --replace '$(MODDESTDIR)' "$out/lib/modules/${kernel.modDirVersion}/kernel/net/wireless/"
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
  '';

  postInstall = ''
    nuke-refs $out/lib/modules/*/kernel/net/wireless/*.ko
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Driver for Realtek 802.11ac, rtl8812au, provides the 8812au mod";
    homepage = "https://github.com/morrownr/8812au-20210629";
    license = licenses.gpl2Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ moni ];
  };
}
