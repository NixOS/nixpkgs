{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  flit-core,

  # dependencies
  astroid,
  jinja2,
  pyyaml,
  sphinx,

  # tests
  beautifulsoup4,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "sphinx-autoapi";
  version = "3.6.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "readthedocs";
    repo = "sphinx-autoapi";
    tag = "v${version}";
    hash = "sha256-dafrvrTl4bVBBaAhTCIPVrSA1pdNlbT5Rou3T//fmKQ=";
  };

  build-system = [ flit-core ];

  dependencies = [
    astroid
    jinja2
    pyyaml
    sphinx
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

  meta = {
    homepage = "https://github.com/readthedocs/sphinx-autoapi";
    changelog = "https://github.com/readthedocs/sphinx-autoapi/blob/${src.tag}/CHANGELOG.rst";
    description = "Provides 'autodoc' style documentation";
    longDescription = ''
      Sphinx AutoAPI provides 'autodoc' style documentation for
      multiple programming languages without needing to load, run, or
      import the project being documented.
    '';
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
