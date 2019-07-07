{ stdenv, buildPythonPackage, fetchPypi
, itsdangerous, hypothesis
, pytest, requests }:

buildPythonPackage rec {
  pname = "Werkzeug";
  version = "0.15.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a0b915f0815982fb2a09161cb8f31708052d0951c3ba433ccc5e1aa276507ca6";
  };

  propagatedBuildInputs = [ itsdangerous ];
  checkInputs = [ pytest requests hypothesis ];

  checkPhase = ''
    pytest ${stdenv.lib.optionalString stdenv.isDarwin "-k 'not test_get_machine_id'"}
  '';

  meta = with stdenv.lib; {
    homepage = "https://palletsprojects.com/p/werkzeug/";
    description = "A WSGI utility library for Python";
    license = licenses.bsd3;
  };
}
