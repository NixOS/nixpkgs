{ stdenv, lib, fetchFromGitHub, vdo, kernel }:

stdenv.mkDerivation rec {
  inherit (vdo) version;
  pname = "kvdo";

  src = fetchFromGitHub {
    owner = "dm-vdo";
    repo = "kvdo";
    rev = version;
    sha256 = "1xl7dwcqx00w1gbpb6vlkn8nchyfj1fsc8c06vgda0sgxp7qs5gn";
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
  };
}
