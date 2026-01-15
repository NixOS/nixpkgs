{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "traits";
  version = "7.1.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-r0d1dH4R4F/+E9O6Rj2S9n8fPRqeT0a6M6ROoisMlkQ=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "traits" ];

  meta = {
    description = "Explicitly typed attributes for Python";
    homepage = "https://pypi.python.org/pypi/traits";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ bot-wxt1221 ];
  };
}
