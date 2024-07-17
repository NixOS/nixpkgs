{
  stdenv,
  lib,
  fetchFromGitHub,
  kernel,
}:

stdenv.mkDerivation rec {
  pname = "gasket";
  version = "1.0-18-unstable-2023-09-05";

  src = fetchFromGitHub {
    owner = "google";
    repo = "gasket-driver";
    rev = "09385d485812088e04a98a6e1227bf92663e0b59";
    sha256 = "fcnqCBh04e+w8g079JyuyY2RPu34M+/X+Q8ObE+42i4=";
  };

  makeFlags = kernel.makeFlags ++ [
    "-C"
    "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "M=$(PWD)"
  ];
  buildFlags = [ "modules" ];

  installFlags = [ "INSTALL_MOD_PATH=${placeholder "out"}" ];
  installTargets = [ "modules_install" ];

  sourceRoot = "${src.name}/src";
  hardeningDisable = [
    "pic"
    "format"
  ];
  nativeBuildInputs = kernel.moduleBuildDependencies;

  meta = with lib; {
    description = "The Coral Gasket Driver allows usage of the Coral EdgeTPU on Linux systems.";
    homepage = "https://github.com/google/gasket-driver";
    license = licenses.gpl2;
    maintainers = [ lib.maintainers.kylehendricks ];
    platforms = platforms.linux;
    broken = versionOlder kernel.version "5.15";
  };
}
