{ lib
, fetchFromGitHub
, buildPythonPackage
, lxml
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
    sha256 = "sha256-lOJ/+8CVJUXdIaZLLF5PpPkG0DzlNgo46kRZ1Xy7Ju0=";
  };

  propagatedBuildInputs = [
    lxml
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "xmlrunner" ];

  meta = with lib; {
    homepage = "https://github.com/xmlrunner/unittest-xml-reporting";
    description = "unittest-based test runner with Ant/JUnit like XML reporting";
    license = licenses.bsd2;
    maintainers = with maintainers; [ rprospero SuperSandro2000 ];
  };
}
