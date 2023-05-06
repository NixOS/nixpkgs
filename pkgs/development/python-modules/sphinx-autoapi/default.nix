{ lib
, astroid
, buildPythonPackage
, fetchPypi
, jinja2
, mock
, pytestCheckHook
, pythonOlder
, pyyaml
, sphinx
, stdenv
, typing-extensions
, unidecode
}:

buildPythonPackage rec {
  pname = "sphinx-autoapi";
  version = "2.0.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-zfR5aMIIUvT+sMzv0J5BS7ggr4r4+C+rFaJLCaPRuro=";
  };

  propagatedBuildInputs = [
    astroid
    jinja2
    pyyaml
    sphinx
    unidecode
  ] ++ lib.optionals (pythonOlder "3.11") [
    typing-extensions
  ];

  nativeCheckInputs = [
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
