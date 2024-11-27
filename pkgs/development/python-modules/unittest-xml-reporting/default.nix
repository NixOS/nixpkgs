{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  lxml,
  pytestCheckHook,
  pythonAtLeast,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "unittest-xml-reporting";
  version = "3.2.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "xmlrunner";
    repo = "unittest-xml-reporting";
    rev = "refs/tags/${version}";
    hash = "sha256-lOJ/+8CVJUXdIaZLLF5PpPkG0DzlNgo46kRZ1Xy7Ju0=";
  };

  build-system = [ setuptools ];

  dependencies = [ lxml ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests =
    lib.optionals (pythonAtLeast "3.11") [
      # AttributeError: 'tuple' object has no attribute 'shortDescription'
      "test_basic_unittest_constructs"
      "test_unexpected_success"
    ]
    ++ lib.optionals (pythonAtLeast "3.12") [ "test_xmlrunner_hold_traceback" ];

  pythonImportsCheck = [ "xmlrunner" ];

  meta = with lib; {
    description = "Unittest-based test runner with Ant/JUnit like XML reporting";
    homepage = "https://github.com/xmlrunner/unittest-xml-reporting";
    changelog = "https://github.com/xmlrunner/unittest-xml-reporting/releases/tag/${version}";
    license = licenses.bsd2;
    maintainers = with maintainers; [ rprospero ];
  };
}
