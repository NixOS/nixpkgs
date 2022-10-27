{ lib, stdenv, fetchFromGitHub, kernel }:

stdenv.mkDerivation rec {
  pname = "qc71_laptop";
  version = "unstable-2022-06-01";

  src = fetchFromGitHub {
    owner = "pobrn";
    repo = "qc71_laptop";
    rev = "28106e0602807d78d1f5fa220ab6148dd6477c1c";
    hash = "sha256-3bhw2HbEVuxPfGMt/eE2nCuMLHzYHRY3nRWPzZxKHro=";
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
