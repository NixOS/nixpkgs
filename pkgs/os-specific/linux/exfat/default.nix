{ stdenv, lib, fetchFromGitHub, fetchpatch, kernel }:


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

  patches = [
    # fix compile-errors in 4.18
    (fetchpatch {
      url = https://aur.archlinux.org/cgit/aur.git/plain/4.18.patch?h=exfat-dkms-git;
      sha256 = "18l5h631w8yja7m2kkcf9h335pvlxms23ls539i81nf6xd6yvd78";
    } )
    # fix compile-errors in 4.20
    (fetchpatch {
      url = https://aur.archlinux.org/cgit/aur.git/plain/4.20.patch?h=exfat-dkms-git;
      sha256 = "05l5x5yvd4vlvnr1bjl751gzcylvm3g9551fqdx7lqphhyiyv3bc";
    })
  ];

  meta = {
    description = "exfat kernel module";
    homepage = https://github.com/dorimanx/exfat-nofuse;
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [ makefu ];
    platforms = lib.platforms.linux;
  };
}
