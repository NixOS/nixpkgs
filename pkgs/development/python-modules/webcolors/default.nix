{ lib
, buildPythonPackage
, fetchPypi
, python
, six
}:

buildPythonPackage rec {
  pname = "webcolors";
  version = "1.10";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7b11194c414dcf4b9bd8fb5ceaafc9da183b27430883c62f620589eb79b91b6e";
  };

  propagatedBuildInputs = [ six ];

  checkPhase = ''
    ${python.interpreter} -m unittest discover -s tests
  '';

  meta = {
    description = "Library for working with color names/values defined by the HTML and CSS specifications";
    homepage = https://bitbucket.org/ubernostrum/webcolors/overview/;
    license = lib.licenses.bsd3;
  };
}
