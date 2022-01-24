{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "textdistance";
  version = "4.2.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a43bb6f71dcccd3fc2060065c9513a7927879680512889749fd1fd800c4bad8e";
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
