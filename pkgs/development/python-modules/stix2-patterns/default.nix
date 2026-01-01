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

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    broken = lib.versionAtLeast antlr4-python3-runtime.version "4.10";
    description = "Validate patterns used to express cyber observable content in STIX Indicators";
    mainProgram = "validate-patterns";
    homepage = "https://github.com/oasis-open/cti-pattern-validator";
    changelog = "https://github.com/oasis-open/cti-pattern-validator/blob/${version}/CHANGELOG.rst";
<<<<<<< HEAD
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fab ];
=======
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
