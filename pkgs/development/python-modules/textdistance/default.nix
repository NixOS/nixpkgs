{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "textdistance";
  version = "4.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-T2vAf2ZX5pNA1MytsleAoScCWy9rccQELi0BByC0yo4=";
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
