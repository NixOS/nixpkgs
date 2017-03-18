{ stdenv, lib, fetchFromGitHub, kernel }:

assert stdenv.lib.versionAtLeast kernel.version "4.4";

stdenv.mkDerivation {
  name = "sch_cake-2017-01-28";

  src = fetchFromGitHub {
    owner = "dtaht";
    repo = "sch_cake";
    rev = "9789742cfc596d48583ba4cdbc8f38d026121fa6";
    sha256 = "03xgkqrv8d9q8rr21awbld0kvwglyinpm71nk16gvm4rd37c5h76";
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
  };
}
