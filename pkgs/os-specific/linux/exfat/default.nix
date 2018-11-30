{ stdenv, lib, fetchFromGitHub, kernel }:


# Upstream build for kernel 4.1 is broken, 3.12 and below seems to be working
assert lib.versionAtLeast kernel.version  "4.2" || lib.versionOlder kernel.version "4.0";

stdenv.mkDerivation rec {
  name = "exfat-nofuse-${version}-${kernel.version}";
  version = "2018-04-16";

  src = fetchFromGitHub {
    owner = "dorimanx";
    repo = "exfat-nofuse";
    rev = "01c30ad52625a7261e1b0d874553b6ca7af25966";
    sha256 = "0n1ibamf1yj8iqapc86lfscnky9p07ngsi4f2kpv3d5r2s6mzsh6";
  };

  hardeningDisable = [ "pic" ];

  nativeBuildInputs = kernel.moduleBuildDependencies;

  makeFlags = [
    "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
  ];

  installPhase = ''
    install -m644 -b -D exfat.ko $out/lib/modules/${kernel.modDirVersion}/kernel/fs/exfat/exfat.ko
  '';

  meta = {
    description = "exfat kernel module";
    homepage = https://github.com/dorimanx/exfat-nofuse;
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [ makefu ];
    platforms = lib.platforms.linux;
    broken = stdenv.lib.versionAtLeast kernel.version "4.18";
  };
}
