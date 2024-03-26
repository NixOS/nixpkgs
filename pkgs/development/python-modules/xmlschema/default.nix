{ lib
, buildPythonPackage
, fetchFromGitHub
, elementpath
, jinja2
, lxml
, pytestCheckHook
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "xmlschema";
  version = "3.0.2";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "sissaschool";
    repo = "xmlschema";
    rev = "refs/tags/v${version}";
    hash = "sha256-jYFhoNx4Oxm7c0LsSQ0xw9fY/yxfQU5JoP5RteHzeYM=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    elementpath
  ];

  nativeCheckInputs = [
    jinja2
    lxml
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "xmlschema"
  ];

  meta = with lib; {
    changelog = "https://github.com/sissaschool/xmlschema/blob/${src.rev}/CHANGELOG.rst";
    description = "XML Schema validator and data conversion library for Python";
    homepage = "https://github.com/sissaschool/xmlschema";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
