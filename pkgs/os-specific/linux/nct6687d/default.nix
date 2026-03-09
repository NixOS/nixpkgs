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
  version = "0-unstable-2026-02-19";

  src = fetchFromGitHub {
    owner = "Fred78290";
    repo = "nct6687d";
    rev = "03037dea69293d77d19e60afb6ff720157cd4672";
    hash = "sha256-iJjnk891BXArXX0oGxP4F+h5Dlv0CkXkYvgMGy49tFY=";
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
    license = with lib.licenses; [ gpl2Only ];
    homepage = "https://github.com/Fred78290/nct6687d/";
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ atemu ];
  };
}
