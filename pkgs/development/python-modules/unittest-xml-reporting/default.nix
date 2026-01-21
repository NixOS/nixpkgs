{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  lxml,
  pytestCheckHook,
  pythonAtLeast,
  setuptools,
}:

buildPythonPackage rec {
  pname = "unittest-xml-reporting";
  version = "4.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "xmlrunner";
    repo = "unittest-xml-reporting";
    tag = version;
    hash = "sha256-9gV/DX/G12bthonBJlMDKaS6Iwt9nF5DrNG33KK7KbU=";
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

  meta = {
    description = "Unittest-based test runner with Ant/JUnit like XML reporting";
    homepage = "https://github.com/xmlrunner/unittest-xml-reporting";
    changelog = "https://github.com/xmlrunner/unittest-xml-reporting/releases/tag/${src.tag}";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ rprospero ];
  };
}
