{ lib, stdenv, fetchFromGitHub, kernel, bc, nukeReferences }:

stdenv.mkDerivation rec {
  pname = "rtl8812au";
  version = "${kernel.version}-unstable-2023-05-11";

  src = fetchFromGitHub {
    owner = "morrownr";
    repo = "8812au-20210629";
    rev = "765d4e4bd5970f4c1c79e63bbe301667e5e029c9";
    hash = "sha256-FF2LVfOpITMJ5LiwsGAudrWStlkKsZUlHvzZs03gb9g=";
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
    maintainers = with maintainers; [ fortuneteller2k ];
  };
}
