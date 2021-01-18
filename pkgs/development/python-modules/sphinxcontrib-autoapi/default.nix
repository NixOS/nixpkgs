{ lib, stdenv
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
  version = "1.5.1";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "19m9yvlqwaw3b05lbb1vcla38irn4riw2ij0vjmnc2xq4f1qfl2d";
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
