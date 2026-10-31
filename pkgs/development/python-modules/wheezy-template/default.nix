{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "wheezy.template";
  version = "3.2.2";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-hknPXHGPPNjRAr0TYVosPaTntsjwQjOKZBCU+qFlIHw=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "wheezy.template" ];

  meta = {
    homepage = "https://wheezytemplate.readthedocs.io/en/latest/";
    description = "Lightweight template library";
    mainProgram = "wheezy.template";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
