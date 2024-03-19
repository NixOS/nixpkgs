{ lib, stdenv, fetchFromGitHub, kernel, bc, nukeReferences }:

stdenv.mkDerivation {
  pname = "rtl8812au";
  version = "${kernel.version}-unstable-2024-01-19";

  src = fetchFromGitHub {
    owner = "morrownr";
    repo = "8812au-20210629";
    rev = "3b921c0beda8583c1d2d1b0b7e4692d11e7ea772";
    hash = "sha256-Ji61Y23uGSTyj3Z5ia9iev5rVzSOv7XY/IfAClhz7Q8=";
  };

  nativeBuildInputs = [ bc nukeReferences ] ++ kernel.moduleBuildDependencies;
  hardeningDisable = [ "pic" "format" ];

  prePatch = ''
    substituteInPlace ./Makefile \
      --replace /lib/modules/ "${kernel.dev}/lib/modules/" \
      --replace /sbin/depmod \# \
      --replace '$(MODDESTDIR)' "$out/lib/modules/${kernel.modDirVersion}/kernel/net/wireless/"
  '';

  makeFlags = [
    "ARCH=${stdenv.hostPlatform.linuxArch}"
    ("CONFIG_PLATFORM_I386_PC=" + (if stdenv.hostPlatform.isx86 then "y" else "n"))
    ("CONFIG_PLATFORM_ARM_RPI=" + (if stdenv.hostPlatform.isAarch then "y" else "n"))
  ] ++ lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
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
