{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, setuptools
, attrs
, click
, consolekit
, dist-meta
, dom-toml
, domdf-python-tools
, handy-archives
, natsort
, packaging
, pyproject-parser
, shippinglabel
, docutils
, editables
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "whey";
  version = "0.0.25";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "repo-helper";
    repo = "whey";
    rev = "v${version}";
    hash = "sha256-fJkqdhwdP0ewIyRGe7F+Ltk2njTds0sBJnBJT9QROqs=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    attrs
    click
    consolekit
    dist-meta
    dom-toml
    domdf-python-tools
    handy-archives
    natsort
    packaging
    pyproject-parser
    shippinglabel
  ];

  passthru.optional-dependencies = {
    all = lib.flatten (lib.attrValues (lib.filterAttrs (n: v: n != "all") passthru.optional-dependencies));
    editable = [
      editables
    ];
    readme = [
      docutils
      pyproject-parser
    ];
  };

  pythonImportsCheck = [ "whey" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  # requires coincidence which hasn't been packaged yet
  doCheck = false;

  meta = {
    description = "A simple Python wheel builder for simple projects";
    homepage = "https://github.com/repo-helper/whey";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
