{
  lib,
  stdenv,
  fetchFromGitHub,
  kernel,
  nix-update-script,
}:

stdenv.mkDerivation rec {
  pname = "qc71_slimbook_laptop";
  version = "0-unstable-2024-12-18";

  src = fetchFromGitHub {
    owner = "Slimbook-Team";
    repo = "qc71_laptop";
    rev = "e130a03628dfc12105f4832ecf59f487f32bcdd7";
    hash = "sha256-xgGxkZyJ2UMgEweUfmSdvsnqwOyghafz2kxGeKCLqqg=";
  };

  patches = [
    ./001-fix-warning.patch
  ];

  nativeBuildInputs = kernel.moduleBuildDependencies;

  makeFlags = kernel.makeFlags ++ [
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
