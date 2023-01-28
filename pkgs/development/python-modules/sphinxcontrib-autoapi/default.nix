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
, unidecode
}:

buildPythonPackage rec {
  pname = "sphinx-autoapi";
  version = "2.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-l9zxtbVM0Njv74Z1lOSk8+LTosDsHlqJHgphvHcEYAY=";
  };

  propagatedBuildInputs = [
    astroid
    jinja2
    pyyaml
    sphinx
    unidecode
  ];

  nativeCheckInputs = [
    mock
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "autoapi"
  ];

  meta = with lib; {
    homepage = "https://github.com/readthedocs/sphinx-autoapi";
    description = "Provides 'autodoc' style documentation";
    longDescription = "Sphinx AutoAPI provides 'autodoc' style documentation for multiple programming languages without needing to load, run, or import the project being documented.";
    license = licenses.mit;
    maintainers = with maintainers; [ karolchmist ];
    broken = stdenv.isDarwin;
  };
}
