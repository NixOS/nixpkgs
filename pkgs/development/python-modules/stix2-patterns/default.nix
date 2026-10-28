{
  lib,
  antlr4-python3-runtime,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "stix2-patterns";
  version = "2.1.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "oasis-open";
    repo = "cti-pattern-validator";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ngRxUeT8ifFM4bpFRtS1ILtTz9lPXtyD8+0MYijWKoM=";
  };

  build-system = [ setuptools ];

  dependencies = [
    antlr4-python3-runtime
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "stix2patterns" ];

  meta = {
    description = "Validate patterns used to express cyber observable content in STIX Indicators";
    homepage = "https://github.com/oasis-open/cti-pattern-validator";
    changelog = "https://github.com/oasis-open/cti-pattern-validator/blob/${finalAttrs.src.tag}/CHANGELOG.rst";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "validate-patterns";
  };
})
