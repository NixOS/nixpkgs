{ stdenv, lib, fetchFromGitHub, vdo, kernel }:

stdenv.mkDerivation rec {
<<<<<<< HEAD
  inherit (vdo);
  pname = "kvdo";
  version = "8.2.1.6"; # bump this version with vdo
=======
  inherit (vdo) version;
  pname = "kvdo";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "dm-vdo";
    repo = "kvdo";
    rev = version;
<<<<<<< HEAD
    hash = "sha256-S5r2Rgx5pWk4IsdIwmfZkuGL/oEQ3prquyVqxjR3cO0=";
  };

  nativeBuildInputs = kernel.moduleBuildDependencies;

=======
    hash = "sha256-4FYTFUIvGjea3bh2GbQYG7hSswVDdNS3S+jWQ9+inpg=";
  };

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  dontConfigure = true;
  enableParallelBuilding = true;

  KSRC = "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build";
  INSTALL_MOD_PATH = placeholder "out";

  preBuild = ''
    makeFlags="$makeFlags -C ${KSRC} M=$(pwd)"
<<<<<<< HEAD
  '';
=======
'';
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  installTargets = [ "modules_install" ];

  meta = with lib; {
    inherit (vdo.meta) license maintainers;
    homepage = "https://github.com/dm-vdo/kvdo";
    description = "A pair of kernel modules which provide pools of deduplicated and/or compressed block storage";
    platforms = platforms.linux;
<<<<<<< HEAD
    broken = kernel.kernelOlder "5.15";
=======
    broken = kernel.kernelOlder "5.15" || kernel.kernelAtLeast "5.17";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
