{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "wrapio";
  version = "2.0.0";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-CUocIbdZ/tJQCxAHzhFpB267ynlXf8Mu+thcRRc0yeg=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "wrapio" ];

  meta = {
    description = "Handling event-based streams";
    homepage = "https://github.com/Exahilosys/wrapio";
    changelog = "https://github.com/Exahilosys/wrapio/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sfrijters ];
  };
})
