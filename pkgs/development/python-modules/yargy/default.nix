{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pymorphy2,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "yargy";
  version = "0.16.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-yRfu+zKkDCPEa2yojWiScHLdAKuU6Q/V3GqwpitZtZM=";
  };

  build-system = [ setuptools ];

  dependencies = [ pymorphy2 ];
  pythonImportsCheck = [ "yargy" ];
  nativeCheckInputs = [ pytestCheckHook ];
  enabledTestPaths = [ "tests" ];

  meta = {
    description = "Rule-based facts extraction for Russian language";
    homepage = "https://github.com/natasha/yargy";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ npatsakula ];
  };
})
