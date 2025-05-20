{
  lib,
  stdenv,
  fetchFromGitHub,
  kernel,
  kernelModuleMakeFlags,
}:

stdenv.mkDerivation rec {
  pname = "ithc";
  version = "0-unstable-2025-07-30";

  src = fetchFromGitHub {
    owner = "quo";
    repo = "ithc-linux";
    rev = "34539af4726d970f9765363bb78b5fd920611a0b";
    hash = "sha256-M7AtkvWKlXJ6MuJoWqj9VuKvd4NJJEO0IAoH/OfbTT4=";
  };

  nativeBuildInputs = kernel.moduleBuildDependencies;

  makeFlags = kernelModuleMakeFlags ++ [
    "VERSION=${version}"
    "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
  ];

  postPatch = ''
    sed -i ./Makefile -e '/depmod/d'
  '';

  installFlags = [ "INSTALL_MOD_PATH=${placeholder "out"}" ];

  meta = with lib; {
    description = "Linux driver for Intel Touch Host Controller";
    homepage = "https://github.com/quo/ithc-linux";
    license = licenses.publicDomain;
    maintainers = with maintainers; [ aacebedo ];
    platforms = platforms.linux;
    broken = kernel.kernelOlder "5.9";
  };
}
