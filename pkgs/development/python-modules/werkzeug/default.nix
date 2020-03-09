{ stdenv, buildPythonPackage, fetchPypi
, itsdangerous, hypothesis
, pytest, requests
, pytest-timeout
 }:

buildPythonPackage rec {
  pname = "Werkzeug";
  version = "0.16.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b353856d37dec59d6511359f97f6a4b2468442e454bd1c98298ddce53cac1f04";
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
