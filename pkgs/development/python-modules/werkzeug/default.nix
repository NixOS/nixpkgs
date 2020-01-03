{ stdenv, buildPythonPackage, fetchPypi
, itsdangerous, hypothesis
, pytest, requests }:

buildPythonPackage rec {
  pname = "Werkzeug";
  version = "0.16.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7280924747b5733b246fe23972186c6b348f9ae29724135a6dfc1e53cea433e7";
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
