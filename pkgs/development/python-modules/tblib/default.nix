{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  setuptools,
}:

buildPythonPackage rec {
  pname = "tblib";
  version = "3.1.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-BkBMLJ8H9m/uLX1q1DrMxG+cM2FxTZuEJuf0fllc1lI=";
  };

  nativeBuildInputs = [ setuptools ];

  meta = {
    description = "Traceback fiddling library. Allows you to pickle tracebacks";
    homepage = "https://github.com/ionelmc/python-tblib";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ teh ];
  };
}
