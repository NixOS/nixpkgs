{ stdenv, lib, fetchFromGitHub, kernel }:

stdenv.mkDerivation rec {
  pname = "gasket";
  version = "1.0-18-unstable-2024-04-25";

  src = fetchFromGitHub {
    owner = "google";
    repo = "gasket-driver";
    rev = "5815ee3908a46a415aac616ac7b9aedcb98a504c";
    sha256 = "O17+msok1fY5tdX1DvqYVw6plkUDF25i8sqwd6mxYf8=";
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
  hardeningDisable = [ "pic" "format" ];
  nativeBuildInputs = kernel.moduleBuildDependencies;

  meta = with lib; {
    description = "Coral Gasket Driver allows usage of the Coral EdgeTPU on Linux systems";
    homepage = "https://github.com/google/gasket-driver";
    license = licenses.gpl2Only;
    maintainers = [ lib.maintainers.kylehendricks ];
    platforms = platforms.linux;
    broken = versionOlder kernel.version "5.15";
  };
}
