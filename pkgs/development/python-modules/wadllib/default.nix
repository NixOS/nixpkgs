{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  lazr-uri,
}:

buildPythonPackage rec {
  pname = "wadllib";
  version = "2.0.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-HtuvI+T6NP6nDJs4C6oqE5sQhq5InrzMxLO2X8lzdCc=";
  };

  build-system = [ setuptools ];

  dependencies = [
    lazr-uri
  ];

  pythonImportsCheck = [ "wadllib" ];

  # pypi tarball has no tests
  doCheck = false;

  meta = with lib; {
    description = "Navigate HTTP resources using WADL files as guides";
    homepage = "https://launchpad.net/wadllib";
    license = licenses.lgpl3Only;
    maintainers = [ ];
  };
}
