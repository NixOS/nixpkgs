{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,

  # build-system
  setuptools,

  # dependencies
  astroid,
  anyascii,
  jinja2,
  pyyaml,
  sphinx,

  # tests
  beautifulsoup4,
  mock,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "sphinx-autoapi";
  version = "3.2.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "sphinx_autoapi";
    inherit version;
    hash = "sha256-+AWA/1DseoZA3J0MPEDqrNOnFbtyx6t4Dk5QTB0HWfs=";
  };

  build-system = [ setuptools ];

  dependencies = [
    anyascii
    astroid
    jinja2
    pyyaml
    sphinx
  ];

  nativeCheckInputs = [
    beautifulsoup4
    mock
    pytestCheckHook
  ];

  disabledTests = [
    # failing typing assertions
    "test_integration"
    "test_annotations"
    # sphinx.errors.SphinxWarning: cannot cache unpickable configuration value: 'autoapi_prepare_jinja_env' (because it contains a function, class, or module object)
    "test_custom_jinja_filters"
  ];

  pythonImportsCheck = [ "autoapi" ];

  meta = with lib; {
    homepage = "https://github.com/readthedocs/sphinx-autoapi";
    changelog = "https://github.com/readthedocs/sphinx-autoapi/blob/v${version}/CHANGELOG.rst";
    description = "Provides 'autodoc' style documentation";
    longDescription = ''
      Sphinx AutoAPI provides 'autodoc' style documentation for
      multiple programming languages without needing to load, run, or
      import the project being documented.
    '';
    license = licenses.mit;
    maintainers = with maintainers; [ karolchmist ];
  };
}
