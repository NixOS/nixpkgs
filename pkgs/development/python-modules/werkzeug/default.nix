{ stdenv, buildPythonPackage, fetchPypi
, itsdangerous, hypothesis
, pytest, requests }:

buildPythonPackage rec {
  pname = "Werkzeug";
  version = "0.15.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0a24d43be6a7dce81bae05292356176d6c46d63e42a0dd3f9504b210a9cfaa43";
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
