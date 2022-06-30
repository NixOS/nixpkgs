{ stdenv, lib, fetchFromGitHub, kernel }:

stdenv.mkDerivation {
  pname = "sch_cake";
  version = "unstable-2017-07-16";

  src = fetchFromGitHub {
    owner = "dtaht";
    repo = "sch_cake";
    rev = "e641a56f27b6848736028f87eda65ac3df9f99f7";
    sha256 = "08582jy01j32b3mj8hf6m8687qrcz64zv2m236j24inlkmd94q21";
  };

  hardeningDisable = [ "pic" ];

  makeFlags = [
    "KERNEL_VERSION=${kernel.version}"
    "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
  ];

  installPhase = ''
    install -v -m 644 -D sch_cake.ko \
      $out/lib/modules/${kernel.modDirVersion}/kernel/net/sched/sch_cake.ko
  '';

  meta = with lib; {
    description = "The cake qdisc scheduler";
    homepage = "https://www.bufferbloat.net/projects/codel/wiki/Cake/";
    license = with licenses; [ bsd3 gpl2 ];
    maintainers = with maintainers; [ fpletz ];
    platforms = platforms.linux;
    broken = lib.versionAtLeast kernel.version "4.13";
  };
}
