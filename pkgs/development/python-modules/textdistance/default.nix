{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "textdistance";
  version = "4.5.0";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Nk1D9PZjV0JmLj5s9TcqhoWUFshKPJsu+dZtRPWkOFw=";
  };

  # There aren't tests
  doCheck = false;

  pythonImportsCheck = [ "textdistance" ];

  meta = with lib; {
    description = "Python library for comparing distance between two or more sequences";
    homepage = "https://github.com/life4/textdistance";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
