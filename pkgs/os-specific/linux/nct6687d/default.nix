{ lib
, stdenv
, fetchFromGitHub
, kernel
, nix-update-script
}:

stdenv.mkDerivation rec {
  pname = "nct6687d";
  version = "0-unstable-2024-11-05";

  src = fetchFromGitHub {
    owner = "Fred78290";
    repo = "nct6687d";
    rev = "2f1a27a29f71797922c74afda6a39ce368e80356";
    hash = "sha256-fnSy3C6R8SHlu+xB+1ID8m4Eqfgb2+2y3DkDlp3blVo=";
  };

  setSourceRoot = ''
    export sourceRoot=$(pwd)/source
  '';

  nativeBuildInputs = kernel.moduleBuildDependencies;

  makeFlags = kernel.makeFlags ++ [
    "-C" "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
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
