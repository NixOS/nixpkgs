{ stdenv, buildPythonPackage, fetchPypi
, itsdangerous, hypothesis
, pytest, requests, glibcLocales }:

buildPythonPackage rec {
  pname = "Werkzeug";
  version = "0.15.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0a73e8bb2ff2feecfc5d56e6f458f5b99290ef34f565ffb2665801ff7de6af7a";
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
