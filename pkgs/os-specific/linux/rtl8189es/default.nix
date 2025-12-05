{
  stdenv,
  lib,
  fetchFromGitHub,
  kernel,
  kernelModuleMakeFlags,
  bc,
  nukeReferences,
}:

stdenv.mkDerivation rec {
  name = "rtl8189es-${kernel.version}-${version}";
  version = "2025-09-26";

  src = fetchFromGitHub {
    owner = "jwrdegoede";
    repo = "rtl8189ES_linux";
    rev = "0a5d04114fac3c9f48a343cb905fbb6a3f9f5df5";
    hash = "sha256-cGPjA5Az0EEbPGG0KfgAqdhbLj54BxoIohWmcR10vPI=";
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

  prePatch = ''
    substituteInPlace ./Makefile --replace /lib/modules/ "${kernel.dev}/lib/modules/"
    substituteInPlace ./Makefile --replace /sbin/depmod \#
    substituteInPlace ./Makefile --replace '$(MODDESTDIR)' "$out/lib/modules/${kernel.modDirVersion}/kernel/net/wireless/"
  '';

  makeFlags = kernelModuleMakeFlags ++ [
    "KSRC=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    (
      "CONFIG_PLATFORM_I386_PC="
      + (if (stdenv.hostPlatform.isi686 || stdenv.hostPlatform.isx86_64) then "y" else "n")
    )
    ("CONFIG_PLATFORM_ARM_RPI=" + (if stdenv.hostPlatform.isAarch then "y" else "n"))
  ];

  preInstall = ''
    mkdir -p "$out/lib/modules/${kernel.modDirVersion}/kernel/net/wireless/"
  '';

  postInstall = ''
    nuke-refs $out/lib/modules/*/kernel/net/wireless/*.ko
  '';

  meta = with lib; {
    description = "Driver for Realtek rtl8189es";
    homepage = "https://github.com/jwrdegoede/rtl8189ES_linux";
    license = licenses.gpl2Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ danielfullmer ];
  };
}
