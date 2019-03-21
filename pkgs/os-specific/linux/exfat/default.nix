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
    # fix compile-errors in 4.18 and 4.20
    # ref: https://github.com/dorimanx/exfat-nofuse/pull/137
    (fetchpatch {
      url = https://github.com/dorimanx/exfat-nofuse/compare/01c30ad52625a7261e1b0d874553b6ca7af25966...f93a47e6414d567a1e7f6ab7f34b015b20f9a050.patch ;
      sha256 = "0w57pi9h6dwjxfgc3zpwy6sr4zw42hn1zj72f7wgfpqrx6d8xkh5";
    } )
  ];

  meta = {
    description = "exfat kernel module";
    homepage = https://github.com/dorimanx/exfat-nofuse;
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [ makefu ];
    platforms = lib.platforms.linux;
  };
}
