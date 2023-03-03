{ stdenv, lib, fetchFromGitHub, vdo, kernel }:

stdenv.mkDerivation rec {
  inherit (vdo) version;
  pname = "kvdo";

  src = fetchFromGitHub {
    owner = "dm-vdo";
    repo = "kvdo";
    rev = version;
    hash = "sha256-4FYTFUIvGjea3bh2GbQYG7hSswVDdNS3S+jWQ9+inpg=";
  };

  dontConfigure = true;
  enableParallelBuilding = true;

  KSRC = "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build";
  INSTALL_MOD_PATH = placeholder "out";

  preBuild = ''
    makeFlags="$makeFlags -C ${KSRC} M=$(pwd)"
'';
  installTargets = [ "modules_install" ];

  meta = with lib; {
    inherit (vdo.meta) license maintainers;
    homepage = "https://github.com/dm-vdo/kvdo";
    description = "A pair of kernel modules which provide pools of deduplicated and/or compressed block storage";
    platforms = platforms.linux;
    broken = kernel.kernelOlder "5.15" || kernel.kernelAtLeast "5.17";
  };
}
