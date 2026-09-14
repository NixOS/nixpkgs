{
  lib,
  attrs,
  buildPythonPackage,
  deprecated,
  fetchPypi,
  hatchling,
  httpx,
  python-dateutil,
  types-deprecated,
  types-python-dateutil,
}:

buildPythonPackage (finalAttrs: {
  pname = "standardwebhooks";
  version = "1.1.0";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-5ctm4hpjVuu5N1rrV/E0hYMyMBWAjUdafBuqpLcYBoo=";
  };

  build-system = [ hatchling ];

  dependencies = [
    attrs
    deprecated
    httpx
    python-dateutil
    types-deprecated
    types-python-dateutil
  ];

  # Tests are no shipped
  doCheck = false;

  pythonImportsCheck = [ "standardwebhooks" ];

  meta = {
    description = "Standard Webhooks";
    homepage = "https://pypi.org/project/standardwebhooks/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
