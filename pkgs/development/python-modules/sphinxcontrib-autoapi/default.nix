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
  version = "1.9.0";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-yJfqM33xatDN4wfL3+K+ziB3iN3hWH+k/IuFfR/F3Lo=";
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
