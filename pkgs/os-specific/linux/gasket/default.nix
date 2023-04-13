{ stdenv, lib, fetchFromGitHub, kernel }:

stdenv.mkDerivation rec {
  pname = "gasket";
  version = "1.0-18";

  src = fetchFromGitHub {
    owner = "google";
    repo = "gasket-driver";
    rev = "97aeba584efd18983850c36dcf7384b0185284b3";
    sha256 = "pJwrrI7jVKFts4+bl2xmPIAD01VKFta2SRuElerQnTo=";
  };

  makeFlags = [
    "-C"
    "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "M=$(PWD)"
  ];
  buildFlags = [ "modules" ];

  installFlags = [ "INSTALL_MOD_PATH=${placeholder "out"}" ];
  installTargets = [ "modules_install" ];

  sourceRoot = "source/src";
  hardeningDisable = [ "pic" "format" ];
  nativeBuildInputs = kernel.moduleBuildDependencies;

  meta = with lib; {
    description = "The Coral Gasket Driver allows usage of the Coral EdgeTPU on Linux systems.";
    homepage = "https://github.com/google/gasket-driver";
    license = licenses.gpl2;
    maintainers = [ lib.maintainers.kylehendricks ];
    platforms = platforms.linux;
  };
}
