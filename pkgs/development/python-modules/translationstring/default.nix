{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "translationstring";
  version = "1.4";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-v5R1ONduaboSqxcoOxA1Wp7PvAeOYSNEP0PyEH9jdvM=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "translationstring" ];

  meta = {
    homepage = "https://pylonsproject.org/";
    description = "Utility library for i18n relied on by various Repoze and Pyramid packages";
    license = lib.licenses.bsd0;
    maintainers = [ ];
  };
})
