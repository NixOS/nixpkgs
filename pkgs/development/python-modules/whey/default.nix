{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  setuptools,
  attrs,
  click,
  consolekit,
  dist-meta,
  docutils,
  dom-toml,
  domdf-python-tools,
  editables,
  handy-archives,
  natsort,
  packaging,
  pyproject-parser,
  pytestCheckHook,
  shippinglabel,
}:

buildPythonPackage rec {
  pname = "whey";
  version = "0.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "repo-helper";
    repo = "whey";
    tag = "v${version}";
    hash = "sha256-s2jZmuFj0gTWVTcXWcBhcu5RBuaf/qMS/xzIpIoG1ZE=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'setuptools!=61.*,<=67.1.0,>=40.6.0' setuptools
  '';

  build-system = [ setuptools ];

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

  pythonImportsCheck = [ "whey" ];

  optional-dependencies = {
    all = lib.flatten (lib.attrValues (lib.filterAttrs (n: v: n != "all") optional-dependencies));
    editable = [
      editables
    ];
    readme = [
      docutils
      pyproject-parser
    ]
    ++ pyproject-parser.optional-dependencies.readme;
  };

  nativeCheckInputs = [
    pytestCheckHook
  ];

  # missing dependency pyproject-examples
  doCheck = false;

  meta = {
    description = "Simple Python wheel builder for simple projects";
    homepage = "https://github.com/repo-helper/whey";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tyberius-prime ];
  };
}
