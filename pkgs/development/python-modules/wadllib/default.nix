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
  version = "1.3.6";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "acd9ad6a2c1007d34ca208e1da6341bbca1804c0e6850f954db04bdd7666c5fc";
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
