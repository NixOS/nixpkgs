{
  lib,
  stdenv,
  fetchFromGitHub,
  kernel,
  kernelModuleMakeFlags,
  nix-update-script,
}:

let
  KDIR = "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build";
in
stdenv.mkDerivation rec {
  pname = "qc71_laptop";
  version = "0-unstable-2025-01-07";

  src = fetchFromGitHub {
    owner = "pobrn";
    repo = "qc71_laptop";
    rev = "ebab4af0b2c5b162bb9f27c80cd284c36b8fb7a9";
    hash = "sha256-sRvxcdocYKnwMH/qYkKj66uClI1bSmMSxXHrHsc7uco=";
  };

  nativeBuildInputs = kernel.moduleBuildDependencies;

  makeFlags = kernelModuleMakeFlags ++ [
    "VERSION=${version}"
    "KDIR=${KDIR}"
    "INSTALL_MOD_PATH=${placeholder "out"}"
    "INSTALL_MOD_DIR=extra"
  ];

  installTargets = [ "modules_install" ];

  installFlags = [
    "-C"
    "${KDIR}"
    "M=$(PWD)"
  ];

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };

  meta = {
    description = "Linux driver for QC71 laptop";
    homepage = "https://github.com/pobrn/qc71_laptop/";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [
      aacebedo
      lucasfa
    ];
    platforms = [ "x86_64-linux" ];
  };
}
