{
  lib,
  buildPythonPackage,
  fetchPypi,
  numpy,
  six,
  withTreeVisualization ? false,
  lxml,
  withXmlSupport ? false,
  pyqt5,
  setuptools,
  legacy-cgi,
}:

buildPythonPackage rec {
  pname = "ete3";
  version = "3.1.3";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-BqO3+o7ZAYewdqjbvlsbYqzulCAdPG6CL1X0SWAe9vI=";
  };

  build-system = [
    setuptools
  ];

  doCheck = false; # Tests are (i) not 3.x compatible, (ii) broken under 2.7

  pythonImportsCheck = [ "ete3" ];

  dependencies = [
    six
    numpy
    legacy-cgi
  ]
  ++ lib.optional withTreeVisualization pyqt5
  ++ lib.optional withXmlSupport lxml;

  meta = {
    description = "Python framework for the analysis and visualization of trees";
    mainProgram = "ete3";
    homepage = "http://etetoolkit.org/";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ delehef ];
  };
}
