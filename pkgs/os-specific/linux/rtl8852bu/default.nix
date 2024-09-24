{ lib, stdenv, fetchFromGitHub, kernel, bc, nukeReferences }:

stdenv.mkDerivation rec {
  pname = "rtl8852bu";
  version = "${kernel.version}-unstable-2024-05-25";

  src = fetchFromGitHub {
    owner = "morrownr";
    repo = pname;
    rev = "1acc7aa085bffec21a91fdc9e293378e06bf25e7";
    hash = "sha256-22vzAdzzM5YnfU8kRWSK3HXxw6BA4FOWXLdWEb7T5IE=";
  };

  nativeBuildInputs = [ bc nukeReferences ] ++ kernel.moduleBuildDependencies;
  hardeningDisable = [ "pic" "format" ];

  postPatch = ''
    substituteInPlace ./Makefile \
      --replace-fail /sbin/depmod \# \
      --replace-fail '$(MODDESTDIR)' "$out/lib/modules/${kernel.modDirVersion}/kernel/net/wireless/"
    substituteInPlace ./platform/i386_pc.mk \
      --replace-fail /lib/modules "${kernel.dev}/lib/modules"
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
    mkdir -p "$out/usr/lib/systemd/system-sleep"
  '';

  postInstall = ''
    nuke-refs $out/lib/modules/*/kernel/net/wireless/*.ko
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Driver for Realtek rtl8852bu and rtl8832bu chipsets, provides the 8852bu mod";
    homepage = "https://github.com/morrownr/rtl8852bu";
    license = licenses.gpl2Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ lonyelon ];
  };
}
