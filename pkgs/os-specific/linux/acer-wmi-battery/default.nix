{
  stdenv,
  lib,
  fetchFromGitHub,
  kernel,
  kernelModuleMakeFlags,
  pahole,
}:

let
  release = "0.1.0-unstable-2025-04-24";

in
stdenv.mkDerivation {
  pname = "acer-wmi-battery";
  version = "${kernel.version}-${release}";

  src = fetchFromGitHub {
    owner = "frederik-h";
    repo = "acer-wmi-battery";
    rev = "0889d3ea54655eaa88de552b334911ce7375952f";
    hash = "sha256-mI6Ob9BmNfwqT3nndWf3jkz8f7tV10odkTnfApsNo+A=";
  };

  nativeBuildInputs = [ pahole ];

  makeFlags = kernelModuleMakeFlags ++ [
    "INSTALL_MOD_PATH=${placeholder "out"}"
    "INSTALL_MOD_DIR=kernel/drivers/platform/x86"
    "INSTALL_MOD_STRIP=1"
    "DEPMOD=true"
  ];

  postPatch = ''
    substituteInPlace Makefile \
      --replace-fail '/lib/modules/$(shell uname -r)/build' ${kernel.dev}/lib/modules/${kernel.modDirVersion}/build
  '';

  enableParallelBuilding = true;

  installFlags = [
    "-C"
    "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "M=$(PWD)"
  ];

  installTargets = [ "modules_install" ];

  meta = {
    description = "Driver for the Acer WMI battery health control interface";
    homepage = "https://github.com/frederik-h/acer-wmi-battery";
    license = lib.licenses.gpl2Only;
    platforms = [
      "i686-linux"
      "x86_64-linux"
    ];
    maintainers = with lib.maintainers; [ peterhoeg ];
  };
}
