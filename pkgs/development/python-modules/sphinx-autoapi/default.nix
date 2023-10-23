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
  version = "2.1.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-+625bnkCDWsOxF2IhRe/gW1rWHotNA++HsMRNeMApsg=";
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
