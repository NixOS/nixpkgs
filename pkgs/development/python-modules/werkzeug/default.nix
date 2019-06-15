{ stdenv, buildPythonPackage, fetchPypi
, itsdangerous, hypothesis
, pytest, requests, glibcLocales }:

buildPythonPackage rec {
  pname = "Werkzeug";
  version = "0.15.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a0b915f0815982fb2a09161cb8f31708052d0951c3ba433ccc5e1aa276507ca6";
  };

  propagatedBuildInputs = [ itsdangerous ];
  checkInputs = [ pytest requests hypothesis ];

  # Hi! New version of Werkzeug? Please double-check that this commit is
  # inclucded, and then remove the following patch.
  # https://github.com/pallets/werkzeug/commit/1cfdcf9824cb20e362979e8f7734012926492165
  patchPhase = ''
    substituteInPlace "tests/test_serving.py" --replace "'python'" "sys.executable"
  '';

  checkPhase = ''
    pytest ${stdenv.lib.optionalString stdenv.isDarwin "-k 'not test_get_machine_id'"}
  '';

  meta = with stdenv.lib; {
    homepage = http://werkzeug.pocoo.org/;
    description = "A WSGI utility library for Python";
    license = licenses.bsd3;
  };
}
