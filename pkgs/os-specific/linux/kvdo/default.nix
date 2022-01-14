{ stdenv, lib, fetchFromGitHub, vdo, kernel }:

stdenv.mkDerivation rec {
  inherit (vdo) version;
  pname = "kvdo";

  src = fetchFromGitHub {
    owner = "dm-vdo";
    repo = "kvdo";
    rev = version;
    sha256 = "1plzvw68x16q8a65cyy0pbycajrl03siyh3yh7qr8kmd2i1p1mxc";
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
