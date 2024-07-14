{
  lib,
  fetchPypi,
  buildPythonPackage,
  docutils,
}:

buildPythonPackage rec {
  pname = "statistics";
  version = "1.0.3.5";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-LcN5uAsHvy3dVIjK0GsrlTHaTdMe2wTcnsDcImSGwTg=";
  };

  propagatedBuildInputs = [ docutils ];

  # statistics package does not have any tests
  doCheck = false;

  meta = {
    description = "Python 2.* port of 3.4 Statistics Module";
    homepage = "https://github.com/digitalemagine/py-statistics";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ];
  };
}
