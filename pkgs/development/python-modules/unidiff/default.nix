{
  lib,
  buildPythonPackage,
  fetchPypi,
  unittestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "unidiff";
  version = "1.0.0";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-Xl1c+rLcmL6Bm3R0erfZ9a+GlTaeyHELk/mrDwrmpEk=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ unittestCheckHook ];

  unittestFlagsArray = [
    "-s"
    "tests"
  ];

  pythonImportsCheck = [ "unidiff" ];

  meta = {
    description = "Unified diff python parsing/metadata extraction library";
    mainProgram = "unidiff";
    homepage = "https://github.com/matiasb/python-unidiff";
    changelog = "https://github.com/matiasb/python-unidiff/raw/v${finalAttrs.version}/HISTORY";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.pbsds ];
  };
})
