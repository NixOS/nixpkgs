{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, sphinx
, importlib-resources
}:

buildPythonPackage rec {
  pname = "sphinx-jupyterbook-latex";
  version = "0.5.0";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit version;
    pname = "sphinx_jupyterbook_latex";
    sha256 = "sha256-XEYsrMcg85loIYvD3ikfgGXGeox0q03H/0wRgTaz+SI=";
  };

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "sphinx>=3,<5" "sphinx>=3"
  '';

  propagatedBuildInputs = [ sphinx ]
    ++ lib.optionals (pythonOlder "3.9") [ importlib-resources ];

  pythonImportsCheck = [ "sphinx_jupyterbook_latex" ];

  meta = with lib; {
    description = "Latex specific features for jupyter book";
    homepage = "https://github.com/executablebooks/sphinx-jupyterbook-latex";
    license = licenses.bsd3;
    maintainers = with maintainers; [ marsam ];
  };
}
