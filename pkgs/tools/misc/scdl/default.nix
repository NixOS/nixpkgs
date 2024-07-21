{ lib, python3Packages, fetchPypi }:

python3Packages.buildPythonApplication rec {
  pname = "scdl";
  version = "2.7.12";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-XZGFsLnQaYaDUUN4on4JegK8I4UFEGzyvAZWbXU25Ec=";
  };

  build-system = [ python3Packages.setuptools ];

  dependencies = with python3Packages; [
    docopt
    mutagen
    termcolor
    requests
    clint
    pathvalidate
    soundcloud-v2
  ];

  # No tests in repository
  doCheck = false;

  pythonImportsCheck = [ "scdl" ];

  meta = with lib; {
    description = "Download Music from Souncloud";
    homepage = "https://github.com/flyingrub/scdl";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ ];
    mainProgram = "scdl";
  };
}
