{
  lib,
  attrs,
  buildPythonPackage,
  deprecated,
  fetchPypi,
  httpx,
  pytestCheckHook,
  python-dateutil,
  setuptools,
  types-deprecated,
  types-python-dateutil,
}:

buildPythonPackage rec {
  pname = "standardwebhooks";
  version = "1.0.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-2UuZwNzqhBVuA62tlPjboy1UVMxo4S7CyCQFG1W7Z/8=";
  };

  build-system = [ setuptools ];

  dependencies = [
    attrs
    deprecated
    httpx
    python-dateutil
    types-deprecated
    types-python-dateutil
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "standardwebhooks" ];

  meta = {
    description = "Standard Webhooks";
    homepage = "https://pypi.org/project/standardwebhooks/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
