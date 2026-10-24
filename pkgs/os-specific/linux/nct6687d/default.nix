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
  version = "0-unstable-2026-10-18";

  src = fetchFromGitHub {
    owner = "Fred78290";
    repo = "nct6687d";
    rev = "7e3d7b36c55f06ab5bb2077bc85329f592996b2a";
    hash = "sha256-Z/7lkvtg+1bKkobaAdUAYGQdRgvbWbKNradIv4MTA30=";
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

  meta = {
    description = "Kernel module for the Nuvoton NCT6687-R chipset found on many B550/B650 motherboards from ASUS and MSI";
    license = lib.licenses.gpl2Only;
    homepage = "https://github.com/Fred78290/nct6687d/";
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ atemu ];
  };
}
