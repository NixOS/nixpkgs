{ lib, stdenv, fetchFromGitHub, kernel, bc, nukeReferences }:

stdenv.mkDerivation rec {
  pname = "rtl8812au";
  version = "${kernel.version}-unstable-2022-08-22";

  src = fetchFromGitHub {
    owner = "morrownr";
    repo = "8812au-20210629";
    rev = "7aa0e0c74551b4e4f319f4b54e00ccbfe588b7ce";
    sha256 = "sha256-BHC1DpWHv/1UvSfj6S5fo/ODZ1VDgLQO2A9EC+BR1JE=";
  };

  nativeBuildInputs = [ bc nukeReferences ];
  buildInputs = kernel.moduleBuildDependencies;
  hardeningDisable = [ "pic" "format" ];

  prePatch = ''
    substituteInPlace ./Makefile \
      --replace /lib/modules/ "${kernel.dev}/lib/modules/" \
      --replace '$(shell uname -r)' "${kernel.modDirVersion}" \
      --replace /sbin/depmod \# \
      --replace '$(MODDESTDIR)' "$out/lib/modules/${kernel.modDirVersion}/kernel/net/wireless/"
  '';

  makeFlags = [
    "ARCH=${stdenv.hostPlatform.linuxArch}"
    "KSRC=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    ("CONFIG_PLATFORM_I386_PC=" + (if stdenv.hostPlatform.isx86 then "y" else "n"))
    ("CONFIG_PLATFORM_ARM_RPI=" + (if stdenv.hostPlatform.isAarch then "y" else "n"))
  ] ++ lib.optional (stdenv.hostPlatform != stdenv.buildPlatform) [
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
