<<<<<<< HEAD
{ lib, python3Packages, fetchPypi, ffmpeg-headless }:

python3Packages.buildPythonApplication rec {
  pname = "twspace-dl";
  version = "2023.7.24.1";

  format = "pyproject";

  src = fetchPypi {
    inherit version;
    pname = "twspace_dl";
    sha256 = "sha256-Oq9k5Nfixf1vihhna7g3ZkqCwEtCdnvlbxIuOnGVoKE=";
=======
{ lib, python3Packages, ffmpeg }:

python3Packages.buildPythonApplication rec {
  pname = "twspace-dl";
  version = "2023.1.22.1";

  format = "pyproject";

  src = python3Packages.fetchPypi {
    inherit version;
    pname = "twspace_dl";
    sha256 = "050e78b4583374351c288114e3b01ab34b0b19ad2d4971d15c5519521cf3f2f4";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = with python3Packages; [ poetry-core ];

  propagatedBuildInputs = with python3Packages; [
<<<<<<< HEAD
    mutagen
    requests
  ];

  makeWrapperArgs = [ "--prefix PATH : ${lib.makeBinPath [ ffmpeg-headless ]}" ];
=======
    requests
  ];

  makeWrapperArgs = [ "--prefix PATH : ${lib.makeBinPath [ ffmpeg ]}" ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  pythonImportsCheck = [ "twspace_dl" ];

  meta = with lib; {
    description = "A python module to download twitter spaces";
    homepage = "https://github.com/HoloArchivists/twspace-dl";
<<<<<<< HEAD
    changelog = "https://github.com/HoloArchivists/twspace-dl/releases/tag/${version}";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ marsam ];
    mainProgram = "twspace_dl";
  };
}
