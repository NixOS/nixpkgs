{
  lib,
  stdenv,
  fetchFromGitHub,
  kernel,
}:

stdenv.mkDerivation rec {
  pname = "qc71_laptop";
  version = "unstable-2023-03-02";

  src = fetchFromGitHub {
    owner = "pobrn";
    repo = "qc71_laptop";
    rev = "8805dc5639f6659addf153a295ad4bbaa2483fa3";
    hash = "sha256-wg7APGArjrl9DEAHTG6BknOBx+UbtNrzziwmLueKPfA=";
  };

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

  meta = with lib; {
    description = "Linux driver for QC71 laptop";
    homepage = "https://github.com/pobrn/qc71_laptop/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ aacebedo ];
    platforms = platforms.linux;
  };
}
