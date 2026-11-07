{
  lib,
  stdenv,
  fetchFromGitHub,
  kernel,
  kernelModuleMakeFlags,
  nix-update-script,
}:

stdenv.mkDerivation rec {
  pname = "qc71_laptop";
  version = "0-unstable-2026-07-23";

  src = fetchFromGitHub {
    owner = "Slimbook-Team";
    repo = "qc71_laptop";
    rev = "7eaaeed9fab43c5852dc156532952ae891cc22d8";
    hash = "sha256-ciLtofIm6UJhoQ195pKE2bPHupraSWP0x+l2kXH5SNY=";
  };

  nativeBuildInputs = kernel.moduleBuildDependencies;

  makeFlags = kernelModuleMakeFlags ++ [
    "VERSION=${version}"
    "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
  ];

  installPhase = ''
    runHook preInstall
    install -D qc71_laptop.ko -t $out/lib/modules/${kernel.modDirVersion}/extra
    runHook postInstall
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };

  meta = {
    description = "Linux kernel platform driver for QC71 based Slimbook laptops";
    homepage = "https://github.com/Slimbook-Team/qc71_laptop";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ l12raptor ];
    platforms = [ "x86_64-linux" ];
  };
}
