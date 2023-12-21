{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, flit-core
, packaging
, sphinx
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "sphinx-jupyterbook-latex";
  version = "1.0.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit version;
    pname = "sphinx_jupyterbook_latex";
    hash = "sha256-9UxmdME/Fhb5qTRD6YubU1P5/dqOObbsVSzPCz5f+2I=";
  };

  nativeBuildInputs = [
    flit-core
  ];

  propagatedBuildInputs = [
    packaging
    sphinx
  ];

  pythonImportsCheck = [ "sphinx_jupyterbook_latex" ];

  meta = with lib; {
    description = "Latex specific features for jupyter book";
    homepage = "https://github.com/executablebooks/sphinx-jupyterbook-latex";
    changelog = "https://github.com/executablebooks/sphinx-jupyterbook-latex/raw/v${version}/CHANGELOG.md";
    license = licenses.bsd3;
    maintainers = with maintainers; [ marsam ];
  };
}
