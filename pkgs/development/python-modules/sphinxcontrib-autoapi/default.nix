{ stdenv
, lib
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
  version = "2.0.0";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-l9zxtbVM0Njv74Z1lOSk8+LTosDsHlqJHgphvHcEYAY=";
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
    broken = stdenv.isDarwin;
    homepage = "https://github.com/readthedocs/sphinx-autoapi";
    description = "Provides 'autodoc' style documentation";
    longDescription = "Sphinx AutoAPI provides 'autodoc' style documentation for multiple programming languages without needing to load, run, or import the project being documented.";
    license = licenses.mit;
    maintainers = with maintainers; [ karolchmist ];
  };

}
