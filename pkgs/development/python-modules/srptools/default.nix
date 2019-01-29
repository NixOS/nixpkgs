{ stdenv, buildPythonPackage, fetchPypi, six, pytest, pytestrunner }:

buildPythonPackage rec {
  pname = "srptools";
  version = "0.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0g0jdkblnd3wv5xgb33g6sfgqnhdcs8a3gqzp5gshq2vawdh8p37";
  };

  propagatedBuildInputs = [ six ];

  checkInputs = [ pytest pytestrunner ];

  meta = with stdenv.lib; {
    description = "Python-Tools to implement Secure Remote Password (SRP) authentication";
    homepage = https://github.com/idlesign/srptools;
    license = licenses.bsd3;
    maintainers = with maintainers; [ elseym ];
  };
}
