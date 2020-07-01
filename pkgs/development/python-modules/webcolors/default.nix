{ lib
, buildPythonPackage
, fetchPypi
, isPy27
, python
, six
}:

buildPythonPackage rec {
  pname = "webcolors";
  version = "1.11.1";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "76f360636957d1c976db7466bc71dcb713bb95ac8911944dffc55c01cb516de6";
  };

  propagatedBuildInputs = [ six ];

  checkPhase = ''
    ${python.interpreter} -m unittest discover -s tests
  '';

  meta = {
    description = "Library for working with color names/values defined by the HTML and CSS specifications";
    homepage = "https://bitbucket.org/ubernostrum/webcolors/overview/";
    license = lib.licenses.bsd3;
  };
}
