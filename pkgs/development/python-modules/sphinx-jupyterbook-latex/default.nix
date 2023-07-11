{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, sphinx
, importlib-resources
}:

buildPythonPackage rec {
  pname = "sphinx-jupyterbook-latex";
  version = "0.5.2";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit version;
    pname = "sphinx_jupyterbook_latex";
    hash = "sha256-2h060Cj1XdvxC5Ewu58k/GDK+2ccvTnf2VU3qvyQly4=";
  };

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "sphinx>=4,<5.1" "sphinx"
  '';

  propagatedBuildInputs = [ sphinx ]
    ++ lib.optionals (pythonOlder "3.9") [ importlib-resources ];

  pythonImportsCheck = [ "sphinx_jupyterbook_latex" ];

  meta = with lib; {
    description = "Latex specific features for jupyter book";
    homepage = "https://github.com/executablebooks/sphinx-jupyterbook-latex";
    changelog = "https://github.com/executablebooks/sphinx-jupyterbook-latex/raw/v${version}/CHANGELOG.md";
    license = licenses.bsd3;
    maintainers = with maintainers; [ marsam ];
  };
}
