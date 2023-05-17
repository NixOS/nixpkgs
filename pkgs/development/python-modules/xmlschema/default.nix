{ lib
, buildPythonPackage
, fetchFromGitHub
, elementpath
, jinja2
, lxml
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "xmlschema";
  version = "2.2.3";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "sissaschool";
    repo = "xmlschema";
    rev = "refs/tags/v${version}";
    hash = "sha256-KTxVUYdflHiC96tALFcMA0JnLt0vj/nSD3ie53lMi50=";
  };

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
