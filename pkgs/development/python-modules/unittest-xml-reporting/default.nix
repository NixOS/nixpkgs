{ lib
, fetchFromGitHub
, buildPythonPackage
, lxml
, pythonAtLeast
, pythonOlder
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "unittest-xml-reporting";
  version = "3.2.0";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "xmlrunner";
    repo = "unittest-xml-reporting";
    rev = version;
    hash = "sha256-lOJ/+8CVJUXdIaZLLF5PpPkG0DzlNgo46kRZ1Xy7Ju0=";
  };

  propagatedBuildInputs = [
    lxml
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pytestFlagsArray = lib.optionals (pythonAtLeast "3.11") [
    # AttributeError: 'tuple' object has no attribute 'shortDescription'
    "--deselect=tests/testsuite.py::XMLTestRunnerTestCase::test_basic_unittest_constructs"
    "--deselect=tests/testsuite.py::XMLTestRunnerTestCase::test_unexpected_success"
  ];

  pythonImportsCheck = [ "xmlrunner" ];

  meta = with lib; {
    homepage = "https://github.com/xmlrunner/unittest-xml-reporting";
    description = "unittest-based test runner with Ant/JUnit like XML reporting";
    license = licenses.bsd2;
    maintainers = with maintainers; [ rprospero SuperSandro2000 ];
  };
}
