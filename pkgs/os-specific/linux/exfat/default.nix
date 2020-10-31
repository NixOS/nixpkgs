{ stdenv, lib, fetchFromGitHub, fetchpatch, kernel }:


# Upstream build for kernel 4.1 is broken, 3.12 and below seems to be working
assert lib.versionAtLeast kernel.version  "4.2" || lib.versionOlder kernel.version "4.0";

stdenv.mkDerivation rec {
  name = "exfat-nofuse-${version}-${kernel.version}";
  version = "2019-09-06";

  src = fetchFromGitHub {
    owner = "AdrianBan";
    repo = "exfat-nofuse";
    rev = "5536f067373c196f152061f5000fe0032dc07c48";
    sha256 = "00mhadsv2iw8z00a6170hwbvk3afx484nn3irmd5f5kmhs34sw7k";
  };

  hardeningDisable = [ "pic" ];

  nativeBuildInputs = kernel.moduleBuildDependencies;

  makeFlags = [
    "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "ARCH=${stdenv.hostPlatform.platform.kernelArch}"
  ] ++ stdenv.lib.optional (stdenv.hostPlatform != stdenv.buildPlatform) [
    "CROSS_COMPILE=${stdenv.cc.targetPrefix}"
  ];

  installPhase = ''
    install -m644 -b -D exfat.ko $out/lib/modules/${kernel.modDirVersion}/kernel/fs/exfat/exfat.ko
  '';

  meta = {
    description = "exfat kernel module";
    inherit (src.meta) homepage;
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [ makefu ];
    platforms = lib.platforms.linux;
    broken = with kernel; kernelAtLeast "5.8";
  };
}
