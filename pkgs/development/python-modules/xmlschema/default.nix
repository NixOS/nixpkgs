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
    # -file://///filer01/MY_HOME/dev/XMLSCHEMA/test.xsd
    # +file:////filer01/MY_HOME/dev/XMLSCHEMA/test.xsd
    "test_normalize_url_slashes"
    "test_normalize_url_with_base_unc_path"
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
