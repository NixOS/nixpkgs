{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, sphinx
, importlib-resources
}:

buildPythonPackage rec {
  pname = "sphinx-jupyterbook-latex";
  version = "0.4.6";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit version;
    pname = "sphinx_jupyterbook_latex";
    sha256 = "8ff3775b11ab4798e6e8ec983601d7aea4c3b8e8b5d28ca758578ede3a791334";
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
