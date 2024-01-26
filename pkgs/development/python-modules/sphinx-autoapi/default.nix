{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder

# build-system
, setuptools

# dependencies
, astroid
, anyascii
, jinja2
, pyyaml
, sphinx

# tests
, beautifulsoup4
, mock
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "sphinx-autoapi";
  version = "3.0.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-CevWdKMrREZyIrD7ipF7l8iVI/INvwW1LLij8OFXFN4=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
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
  ];

  pythonImportsCheck = [
    "autoapi"
  ];

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
