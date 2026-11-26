{
  lib,
  buildPythonPackage,
  elementpath,
  fetchFromGitHub,
  jinja2,
  lxml,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "xmlschema";
  version = "4.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sissaschool";
    repo = "xmlschema";
    tag = "v${version}";
    hash = "sha256-O34MHsP4BC5fALHDzXJBWGtcRifdL3dJNwW721QN4vA=";
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

  meta = {
    description = "XML Schema validator and data conversion library for Python";
    homepage = "https://github.com/sissaschool/xmlschema";
    changelog = "https://github.com/sissaschool/xmlschema/blob/${src.tag}/CHANGELOG.rst";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
