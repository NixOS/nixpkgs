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
<<<<<<< HEAD
  version = "0-unstable-2025-10-24";
=======
  version = "0-unstable-2025-08-23";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "Fred78290";
    repo = "nct6687d";
<<<<<<< HEAD
    rev = "15089b021875bf69381735e504268aaf269a5724";
    hash = "sha256-HRaB+Fy+u7kdyZFFr7hfKN8rz10hT1DW9bN7K5NW7FM=";
=======
    rev = "b4c600d60ad26f01d11f75d40cb574c5e77e11b6";
    hash = "sha256-w/4mZZbGi+tTEJW25h+E8yi4YYfv7cxaMlVR7TkQCdc=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
  meta = {
    description = "Kernel module for the Nuvoton NCT6687-R chipset found on many B550/B650 motherboards from ASUS and MSI";
    license = with lib.licenses; [ gpl2Only ];
    homepage = "https://github.com/Fred78290/nct6687d/";
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ atemu ];
=======
  meta = with lib; {
    description = "Kernel module for the Nuvoton NCT6687-R chipset found on many B550/B650 motherboards from ASUS and MSI";
    license = with licenses; [ gpl2Only ];
    homepage = "https://github.com/Fred78290/nct6687d/";
    platforms = platforms.linux;
    maintainers = with maintainers; [ atemu ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
