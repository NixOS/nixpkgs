{
  buildPythonPackage,
  lib,
  fetchPypi,
  setuptools-scm,
  importlib-metadata,
}:

buildPythonPackage rec {
  pname = "pluggy";
  version = "0.13.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "15b2acde666561e1298d71b523007ed7364de07029219b604cf808bfa1c765b0";
  };

  checkPhase = ''
    py.test
  '';

  # To prevent infinite recursion with pytest
  doCheck = false;

  nativeBuildInputs = [ setuptools-scm ];

  propagatedBuildInputs = [ importlib-metadata ];

  meta = {
    description = "Plugin and hook calling mechanisms for Python";
    homepage = "https://github.com/pytest-dev/pluggy";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
  };
}
