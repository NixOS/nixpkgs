{
  lib,
  stdenv,
  fetchFromGitHub,
  kernel,
  kernelModuleMakeFlags,
  nix-update-script,
}:

stdenv.mkDerivation rec {
  pname = "qc71_slimbook_laptop";
  version = "0-unstable-2025-02-17";

  src = fetchFromGitHub {
    owner = "Slimbook-Team";
    repo = "qc71_laptop";
    rev = "f1475751a272a7cf78321f60390da6108b4b3904";
    hash = "sha256-/D3/v0mKaExMlUnGGTtRDEXOlylMWYeylJih/gzqqGA=";
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
    extraArgs = [ "--version=branch=slimbook" ];
  };

  meta = with lib; {
    description = "Linux driver for QC71 laptop, with Slimbook patches";
    homepage = "https://github.com/Slimbook-Team/qc71_laptop/";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ lucasfa ];
    platforms = platforms.linux;
  };
}
