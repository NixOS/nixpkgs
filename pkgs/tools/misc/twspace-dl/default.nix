{ lib, python3Packages, fetchPypi, ffmpeg-headless }:

python3Packages.buildPythonApplication rec {
  pname = "twspace-dl";
  version = "2023.7.24.1";

  format = "pyproject";

  src = fetchPypi {
    inherit version;
    pname = "twspace_dl";
    sha256 = "sha256-Oq9k5Nfixf1vihhna7g3ZkqCwEtCdnvlbxIuOnGVoKE=";
  };

  nativeBuildInputs = with python3Packages; [ poetry-core ];

  propagatedBuildInputs = with python3Packages; [
    mutagen
    requests
  ];

  makeWrapperArgs = [ "--prefix PATH : ${lib.makeBinPath [ ffmpeg-headless ]}" ];

  pythonImportsCheck = [ "twspace_dl" ];

  meta = with lib; {
    description = "Python module to download twitter spaces";
    homepage = "https://github.com/HoloArchivists/twspace-dl";
    changelog = "https://github.com/HoloArchivists/twspace-dl/releases/tag/${version}";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ ];
    mainProgram = "twspace_dl";
  };
}
