{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "textdistance";
  version = "4.6.0";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-cyxQMVzU7pRjg4ZDzxnWkiEwLDYDHqpgcMMMwKpdqMo=";
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
