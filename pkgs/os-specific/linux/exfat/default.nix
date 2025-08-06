{
  stdenv,
  lib,
  fetchFromGitHub,
  kernel,
}:

stdenv.mkDerivation rec {
  name = "exfat-nofuse-${version}-${kernel.version}";
  version = "2020-04-15";

  src = fetchFromGitHub {
    owner = "barrybingo";
    repo = "exfat-nofuse";
    rev = "297a5739cd4a942a1d814d05a9cd9b542e7b8fc8";
    sha256 = "14jahy7n6pr482fjfrlf9ck3f2rkr5ds0n5r85xdfsla37ria26d";
  };

  hardeningDisable = [ "pic" ];

  nativeBuildInputs = kernel.moduleBuildDependencies;

  makeFlags = [
    "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "ARCH=${stdenv.hostPlatform.linuxArch}"
  ]
  ++ lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
    "CROSS_COMPILE=${stdenv.cc.targetPrefix}"
  ];

  installPhase = ''
    install -m644 -b -D exfat.ko $out/lib/modules/${kernel.modDirVersion}/kernel/fs/exfat/exfat.ko
  '';

  meta = {
    description = "exfat kernel module";
    inherit (src.meta) homepage;
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ makefu ];
    platforms = lib.platforms.linux;
    broken = true;
  };
}
