{ stdenv, fetchFromGitHub, kernel, bc, nukeReferences }:

stdenv.mkDerivation rec {
  name = "rtl8812au-${kernel.version}-${version}";
  version = "5.2.20.2_28373.20190903";

  src = fetchFromGitHub {
    owner = "zebulon2";
    repo = "rtl8812au-driver-5.2.20";
    rev = "30d47a0a3f43ccb19e8fd59fe93d74a955147bf2";
    sha256 = "1fy0f8ihxd0i5kr8gmky8v8xl0ns6bhxfdn64c97c5irzdvg37sr";
  };

  nativeBuildInputs = [ bc nukeReferences ];
  buildInputs = kernel.moduleBuildDependencies;

  hardeningDisable = [ "pic" "format" ];

  prePatch = ''
    substituteInPlace ./Makefile --replace /lib/modules/ "${kernel.dev}/lib/modules/"
    substituteInPlace ./Makefile --replace '$(shell uname -r)' "${kernel.modDirVersion}"
    substituteInPlace ./Makefile --replace /sbin/depmod \#
    substituteInPlace ./Makefile --replace '$(MODDESTDIR)' "$out/lib/modules/${kernel.modDirVersion}/kernel/net/wireless/"
  '';

  makeFlags = [
    "ARCH=${stdenv.hostPlatform.platform.kernelArch}"
    "KSRC=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    ("CONFIG_PLATFORM_I386_PC=" + (if (stdenv.hostPlatform.isi686 || stdenv.hostPlatform.isx86_64) then "y" else "n"))
    ("CONFIG_PLATFORM_ARM_RPI=" + (if (stdenv.hostPlatform.isAarch32 || stdenv.hostPlatform.isAarch64) then "y" else "n"))
  ] ++ stdenv.lib.optional (stdenv.hostPlatform != stdenv.buildPlatform) [
    "CROSS_COMPILE=${stdenv.cc.targetPrefix}"
  ];

  preInstall = ''
    mkdir -p "$out/lib/modules/${kernel.modDirVersion}/kernel/net/wireless/"
  '';

  postInstall = ''
    nuke-refs $out/lib/modules/*/kernel/net/wireless/*.ko
  '';

  meta = with stdenv.lib; {
    description = "Driver for Realtek 802.11ac, rtl8812au, provides the 8812au mod";
    homepage = https://github.com/zebulon2/rtl8812au-driver-5.2.20;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ danielfullmer ];
  };
}
