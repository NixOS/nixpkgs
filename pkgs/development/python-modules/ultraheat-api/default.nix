{
  lib,
  buildPythonPackage,
  fetchPypi,
  serialx,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "ultraheat-api";
  version = "0.6.0";
  pyproject = true;

  src = fetchPypi {
    pname = "ultraheat_api";
    inherit (finalAttrs) version;
    hash = "sha256-YWasu54E/8xDZPvaRHph6EM0+UXeRGE2CXheYdwDpNE=";
  };

  build-system = [ setuptools ];

  dependencies = [ serialx ];

  # Source is not tagged, only PyPI releases
  doCheck = false;

  pythonImportsCheck = [ "ultraheat_api" ];

  meta = {
    description = "Module for working with data from Landis+Gyr Ultraheat heat meter unit";
    homepage = "https://github.com/vpathuis/uh50";
    changelog = "https://github.com/vpathuis/ultraheat/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
