{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,

  # build-system
  flit-core,

  # dependencies
  astroid,
  jinja2,
  pyyaml,
  sphinx,
  stdlib-list,

  # tests
  beautifulsoup4,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "sphinx-autoapi";
  version = "3.6.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "readthedocs";
    repo = "sphinx-autoapi";
    tag = "v${version}";
    hash = "sha256-pDfGNpDyrU4q48ZHKqfN8OrxKICfIhac2qMJDB1iE0I=";
  };

  build-system = [ flit-core ];

  dependencies = [
    astroid
    jinja2
    pyyaml
    sphinx
  ]
  ++ lib.optionals (pythonOlder "3.10") [
    stdlib-list
  ];

  nativeCheckInputs = [
    beautifulsoup4
    pytestCheckHook
  ];

  disabledTests = [
    # require network access
    "test_integration"
  ];

  pythonImportsCheck = [ "autoapi" ];

  meta = with lib; {
    homepage = "https://github.com/readthedocs/sphinx-autoapi";
    changelog = "https://github.com/readthedocs/sphinx-autoapi/blob/${src.tag}/CHANGELOG.rst";
    description = "Provides 'autodoc' style documentation";
    longDescription = ''
      Sphinx AutoAPI provides 'autodoc' style documentation for
      multiple programming languages without needing to load, run, or
      import the project being documented.
    '';
    license = licenses.mit;
    maintainers = [ ];
  };
}
