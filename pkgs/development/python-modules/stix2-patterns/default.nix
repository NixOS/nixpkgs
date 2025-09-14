{
  lib,
  antlr4-python3-runtime,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  six,
}:

buildPythonPackage rec {
  pname = "stix2-patterns";
  version = "2.0.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "oasis-open";
    repo = "cti-pattern-validator";
    tag = "v${version}";
    hash = "sha256-lFgnvI5a7U7/Qj4Pqjr3mx4TNDnC2/Ru7tVG7VggR7Y=";
  };

  build-system = [ setuptools ];

  dependencies = [
    antlr4-python3-runtime
    six
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "stix2patterns" ];

  meta = with lib; {
    broken = lib.versionAtLeast antlr4-python3-runtime.version "4.10";
    description = "Validate patterns used to express cyber observable content in STIX Indicators";
    mainProgram = "validate-patterns";
    homepage = "https://github.com/oasis-open/cti-pattern-validator";
    changelog = "https://github.com/oasis-open/cti-pattern-validator/blob/${version}/CHANGELOG.rst";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
  };
}
