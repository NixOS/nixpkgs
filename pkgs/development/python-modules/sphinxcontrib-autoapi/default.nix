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
  version = "1.8.1";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "842c0a8f49c824803f7edee31cb1cabd5001a987553bec7b4681283ec9e47d4a";
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
