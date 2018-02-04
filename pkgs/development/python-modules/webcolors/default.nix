{ lib
, buildPythonPackage
, fetchPypi
, python
}:

buildPythonPackage rec {
  pname = "webcolors";
  version = "1.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e47e68644d41c0b1f1e4d939cfe4039bdf1ab31234df63c7a4f59d4766487206";
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