{
  lib,
  buildPythonPackage,
  fetchPypi,
  idna,
}:

buildPythonPackage rec {
  pname = "hyperlink";
  version = "21.0.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Qnr5V9qli8kJRxxsQPdMVFD6Ej3Qk/xT79LpHScFpWs=";
  };

  propagatedBuildInputs = [ idna ];

  meta = {
    description = "Featureful, correct URL for Python";
    homepage = "https://github.com/python-hyper/hyperlink";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = [ ];
  };
}
