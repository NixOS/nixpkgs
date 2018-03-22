{ lib
, buildPythonPackage
, fetchPypi
, python
}:

buildPythonPackage rec {
  pname = "webcolors";
  version = "1.8.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "030562f624467a9901f0b455fef05486a88cfb5daa1e356bd4aacea043850b59";
  };

  checkPhase = ''
    ${python.interpreter} -m unittest discover -s tests
  '';

  meta = {
    description = "Library for working with color names/values defined by the HTML and CSS specifications";
    homepage = https://bitbucket.org/ubernostrum/webcolors/overview/;
    license = lib.licenses.bsd3;
  };
}