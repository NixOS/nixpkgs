{
  lib,
  buildPythonPackage,
  elementpath,
  fetchFromGitHub,
  jinja2,
  lxml,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "xmlschema";
  version = "3.3.2";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "sissaschool";
    repo = "xmlschema";
    rev = "refs/tags/v${version}";
    hash = "sha256-cZVNgY0Y9tE+ud8596Ujidc7aq+Gon9x6q/XDCuJ9oI=";
  };

  build-system = [ setuptools ];

  dependencies = [ elementpath ];

  nativeCheckInputs = [
    jinja2
    lxml
    pytestCheckHook
  ];

  disabledTests = [
    # Incorrect error message in pickling test for Python 3.12 in Debian
    # https://github.com/sissaschool/xmlschema/issues/412
    "test_pickling_subclassed_schema__issue_263"
  ];

  pythonImportsCheck = [ "xmlschema" ];

  meta = with lib; {
    description = "XML Schema validator and data conversion library for Python";
    homepage = "https://github.com/sissaschool/xmlschema";
    changelog = "https://github.com/sissaschool/xmlschema/blob/${src.rev}/CHANGELOG.rst";
    license = licenses.mit;
    maintainers = [ ];
  };
}
