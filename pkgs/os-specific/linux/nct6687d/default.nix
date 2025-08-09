{
  lib,
  stdenv,
  fetchFromGitHub,
  kernel,
  kernelModuleMakeFlags,
  nix-update-script,
}:

stdenv.mkDerivation {
  pname = "nct6687d";
  version = "0-unstable-2025-06-30";

  src = fetchFromGitHub {
    owner = "Fred78290";
    repo = "nct6687d";
    rev = "66ddfee6fb6b8515fb8a27698acbb9b2b8e9d2c2";
    hash = "sha256-orlYpmU+wIxVyPjuk/faQrGKtEcliWI2Hgxcw5DReX4=";
  };

  setSourceRoot = ''
    export sourceRoot=$(pwd)/source
  '';

  nativeBuildInputs = kernel.moduleBuildDependencies;

  makeFlags = kernelModuleMakeFlags ++ [
    "-C"
    "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "M=$(sourceRoot)"
  ];

  buildFlags = [ "modules" ];
  installFlags = [ "INSTALL_MOD_PATH=${placeholder "out"}" ];
  installTargets = [ "modules_install" ];

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch=main" ];
  };

  meta = with lib; {
    description = "Kernel module for the Nuvoton NCT6687-R chipset found on many B550/B650 motherboards from ASUS and MSI";
    license = with licenses; [ gpl2Only ];
    homepage = "https://github.com/Fred78290/nct6687d/";
    platforms = platforms.linux;
    maintainers = with maintainers; [ atemu ];
  };
}
