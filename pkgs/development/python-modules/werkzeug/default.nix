{ lib, stdenv, buildPythonPackage, fetchPypi
, itsdangerous, hypothesis
, pytestCheckHook, requests
, pytest-timeout
, isPy3k
 }:

buildPythonPackage rec {
  pname = "Werkzeug";
  version = "1.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6c80b1e5ad3665290ea39320b91e1be1e0d5f60652b964a3070216de83d2e47c";
  };

  propagatedBuildInputs = [ itsdangerous ];
  checkInputs = [ pytestCheckHook requests hypothesis pytest-timeout ];

  disabledTests = lib.optionals stdenv.isDarwin [
    "test_get_machine_id"
  ];

  meta = with lib; {
    homepage = "https://palletsprojects.com/p/werkzeug/";
    description = "A WSGI utility library for Python";
    license = licenses.bsd3;
  };
}
