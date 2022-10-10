{ lib, python3Packages, ffmpeg }:

python3Packages.buildPythonApplication rec {
  pname = "twspace-dl";
  version = "2022.6.6.1";

  format = "setuptools";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "47622f306f2601185b00d6ef24f821810adcc581b7361c423eec979263725afc";
  };

  propagatedBuildInputs = with python3Packages; [
    requests
  ];

  makeWrapperArgs = [ "--prefix PATH : ${lib.makeBinPath [ ffmpeg ]}" ];

  pythonImportsCheck = [ "twspace_dl" ];

  meta = with lib; {
    description = "A python module to download twitter spaces";
    homepage = "https://github.com/HoloArchivists/twspace-dl";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ marsam ];
    mainProgram = "twspace_dl";
  };
}
