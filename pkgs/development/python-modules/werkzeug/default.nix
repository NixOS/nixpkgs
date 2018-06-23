{ stdenv, buildPythonPackage, fetchPypi
, itsdangerous, hypothesis
, pytest, requests, glibcLocales }:

buildPythonPackage rec {
  pname = "Werkzeug";
  version = "0.14.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c3fd7a7d41976d9f44db327260e263132466836cef6f91512889ed60ad26557c";
  };

  propagatedBuildInputs = [ itsdangerous ];
  checkInputs = [ pytest requests glibcLocales hypothesis ];

  checkPhase = ''
    LC_ALL="en_US.UTF-8" py.test ${stdenv.lib.optionalString stdenv.isDarwin "-k 'not test_get_machine_id'"}
  '';

  meta = with stdenv.lib; {
    homepage = http://werkzeug.pocoo.org/;
    description = "A WSGI utility library for Python";
    license = licenses.bsd3;
  };
}
