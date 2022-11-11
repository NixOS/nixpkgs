{ lib, stdenv, fetchzip, fetchpatch, kernel }:

stdenv.mkDerivation rec {
  pname = "dpdk-kmods";
  version = "2022-08-29";

  src = fetchzip {
    url = "https://git.dpdk.org/dpdk-kmods/snapshot/dpdk-kmods-4a589f7bed00fc7009c93d430bd214ac7ad2bb6b.tar.xz";
    sha256 = "sha256-l9asJuw2nl63I1BxK6udy2pNunRiMJxyoXeg9V5+WgI=";
  };

  patches = [
    (fetchpatch {
      url = "https://git.launchpad.net/ubuntu/+source/dpdk-kmods/plain/debian/patches/0001-support-linux-5.18.patch?id=9d628c02c169d8190bc2cb6afd81e4d364c382cd";
      sha256 = "sha256-j4kpx1DOnmf5lFxOhaVFNT7prEy1jrJERX2NFaybTPU=";
    })
  ];

  hardeningDisable = [ "pic" ];

  makeFlags = kernel.makeFlags ++ [
    "INSTALL_MOD_PATH=${placeholder "out"}"
  ];
  KSRC = "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build";

  nativeBuildInputs = kernel.moduleBuildDependencies;

  preBuild = "cd linux/igb_uio";

  installPhase = ''
    make -C ${KSRC} M=$(pwd) modules_install $makeFlags
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Kernel modules for DPDK";
    homepage = "https://git.dpdk.org/dpdk-kmods/";
    license = licenses.gpl2Only;
    maintainers = [ maintainers.mic92 ];
    platforms = platforms.linux;
  };
}
