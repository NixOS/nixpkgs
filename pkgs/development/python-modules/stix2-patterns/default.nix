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
    rev = "refs/tags/v${version}";
    hash = "sha256-lFgnvI5a7U7/Qj4Pqjr3mx4TNDnC2/Ru7tVG7VggR7Y=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "antlr4-python3-runtime~=" "antlr4-python3-runtime>="
  '';

  build-system = [ setuptools ];

  dependencies = [
    antlr4-python3-runtime
    six
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "stix2patterns" ];

  disabledTestPaths = [
    # Exception: Could not deserialize ATN with version  (expected 4)
    "stix2patterns/test/v20/test_inspector.py"
    "stix2patterns/test/v21/test_inspector.py"
    "stix2patterns/test/v20/test_validator.py"
    "stix2patterns/test/v21/test_validator.py"
  ];

  meta = with lib; {
    description = "Validate patterns used to express cyber observable content in STIX Indicators";
    mainProgram = "validate-patterns";
    homepage = "https://github.com/oasis-open/cti-pattern-validator";
    changelog = "https://github.com/oasis-open/cti-pattern-validator/blob/${version}/CHANGELOG.rst";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
  };
}
