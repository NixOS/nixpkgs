{ stdenv, lib, fetchFromGitHub, fetchpatch, kernel }:

stdenv.mkDerivation rec {
  # linux kernel above 5.7 comes with its own exfat implementation https://github.com/arter97/exfat-linux/issues/27
  # Assertion moved here due to some tests unintenionally triggering it,
  # e.g. nixosTests.kernel-latest; it's unclear how/why so far.
  assertion = assert lib.versionOlder kernel.version "5.8"; null;

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
  ] ++ lib.optional (stdenv.hostPlatform != stdenv.buildPlatform) [
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
    broken = true;
  };
}
