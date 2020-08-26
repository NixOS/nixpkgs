{ stdenv, buildPythonPackage, fetchPypi, six, pytest, pytestrunner }:

buildPythonPackage rec {
  pname = "srptools";
  version = "1.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5754f639ed1888f47c1185d74e8907ff9af4c0ccc1c8be2ef19339d0a1327f4d";
  };

  propagatedBuildInputs = [ six ];

  checkInputs = [ pytest pytestrunner ];

  meta = with stdenv.lib; {
    description = "Python-Tools to implement Secure Remote Password (SRP) authentication";
    homepage = "https://github.com/idlesign/srptools";
    license = licenses.bsd3;
    maintainers = with maintainers; [ elseym ];
  };
}
