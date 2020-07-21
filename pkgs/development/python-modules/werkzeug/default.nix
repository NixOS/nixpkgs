{ stdenv, buildPythonPackage, fetchPypi
, itsdangerous, hypothesis
, pytest, requests
, pytest-timeout
 }:

buildPythonPackage rec {
  pname = "Werkzeug";
  version = "1.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6c80b1e5ad3665290ea39320b91e1be1e0d5f60652b964a3070216de83d2e47c";
  };

  propagatedBuildInputs = [ itsdangerous ];
  checkInputs = [ pytest requests hypothesis pytest-timeout ];

  checkPhase = ''
    pytest ${stdenv.lib.optionalString stdenv.isDarwin "-k 'not test_get_machine_id'"}
  '';

  meta = with stdenv.lib; {
    homepage = "https://palletsprojects.com/p/werkzeug/";
    description = "A WSGI utility library for Python";
    license = licenses.bsd3;
  };
}
