{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "textdistance";
  version = "4.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-MzGJQ/TV1fBdV3oNvtseToO/ajUVPovOrOUsxR4fCOM=";
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
