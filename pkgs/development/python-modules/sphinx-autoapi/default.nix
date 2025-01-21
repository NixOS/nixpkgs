{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,

  # build-system
  setuptools,

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
  version = "3.3.2";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "sphinx_autoapi";
    inherit version;
    hash = "sha256-6/i0Sy66tcKPAmPsbC+KzdFW6bLVOaWOyjnS82hEUXM=";
  };

  build-system = [ setuptools ];

  dependencies =
    [
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
