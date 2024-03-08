{ stdenv, lib, fetchFromGitHub, vdo, kernel }:

stdenv.mkDerivation rec {
  inherit (vdo);
  pname = "kvdo";
  version = "8.2.1.6"; # bump this version with vdo

  src = fetchFromGitHub {
    owner = "dm-vdo";
    repo = "kvdo";
    rev = version;
    hash = "sha256-S5r2Rgx5pWk4IsdIwmfZkuGL/oEQ3prquyVqxjR3cO0=";
  };

  nativeBuildInputs = kernel.moduleBuildDependencies;

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
    broken = kernel.kernelOlder "5.15";
  };
}
