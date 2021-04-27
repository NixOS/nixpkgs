{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "textdistance";
  version = "4.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "114j3ignw4y9yq1cp08p4bfw518vyr3p0h8ba2mikwy74qxxzy26";
  };

  # There aren't tests
  doCheck = false;

  pythonImportsCheck = [ "textdistance" ];

  meta = with lib; {
    description = "Python library for comparing distance between two or more sequences";
    homepage = "https://github.com/life4/textdistance";
    license = licenses.mit;
    maintainers = with maintainers; [ eduardosm ];
  };
}
