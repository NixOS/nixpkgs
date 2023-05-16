{ lib, stdenv, fetchFromGitHub, kernel }:

stdenv.mkDerivation rec {
  pname = "qc71_laptop";
<<<<<<< HEAD
  version = "unstable-2023-03-02";
=======
  version = "unstable-2022-06-01";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "pobrn";
    repo = "qc71_laptop";
<<<<<<< HEAD
    rev = "8805dc5639f6659addf153a295ad4bbaa2483fa3";
    hash = "sha256-wg7APGArjrl9DEAHTG6BknOBx+UbtNrzziwmLueKPfA=";
=======
    rev = "28106e0602807d78d1f5fa220ab6148dd6477c1c";
    hash = "sha256-3bhw2HbEVuxPfGMt/eE2nCuMLHzYHRY3nRWPzZxKHro=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
