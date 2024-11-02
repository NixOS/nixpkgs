{
  lib,
  buildPythonPackage,
  fetchPypi,
  isPy3k,
  setuptools,
  lazr-uri,
}:

buildPythonPackage rec {
  pname = "wadllib";
  version = "2.0.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-HtuvI+T6NP6nDJs4C6oqE5sQhq5InrzMxLO2X8lzdCc=";
  };

  propagatedBuildInputs = [
    setuptools
    lazr-uri
  ];

  doCheck = isPy3k;

  meta = with lib; {
    description = "Navigate HTTP resources using WADL files as guides";
    homepage = "https://launchpad.net/wadllib";
    license = licenses.lgpl3;
    maintainers = [ ];
  };
}
