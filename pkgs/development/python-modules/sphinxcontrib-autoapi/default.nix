{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, astroid
, jinja2
, sphinx
, pyyaml
, unidecode
, mock
, pytest
}:

buildPythonPackage rec {
  pname = "sphinx-autoapi";
  version = "1.7.0";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "48caa054a99c21156e9a1d26559281dc27f86ab8ef8bb6ef160f8cd9f4a0053d";
  };

  propagatedBuildInputs = [ astroid jinja2 pyyaml sphinx unidecode ];

  checkInputs = [
    mock
    pytest
  ];

  checkPhase = ''
    pytest
  '';

  meta = with lib; {
    homepage = "https://github.com/readthedocs/sphinx-autoapi";
    description = "Provides 'autodoc' style documentation";
    longDescription = "Sphinx AutoAPI provides 'autodoc' style documentation for multiple programming languages without needing to load, run, or import the project being documented.";
    license = licenses.mit;
    maintainers = with maintainers; [ karolchmist ];
  };

}
