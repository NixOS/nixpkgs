{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, flit-core
, sphinx
}:

buildPythonPackage rec {
  pname = "sphinx-design";
  version = "0.5.0";

  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit version;
    pname = "sphinx_design";
    hash = "sha256-6OUTrOpvktFcbeOzTpVEWPJFuOdhtFtjlQ9lNzNSqwA=";
  };

  nativeBuildInputs = [ flit-core ];

  propagatedBuildInputs = [ sphinx ];

  pythonImportsCheck = [ "sphinx_design" ];

  meta = with lib; {
    description = "A sphinx extension for designing beautiful, view size responsive web components";
    homepage = "https://github.com/executablebooks/sphinx-design";
    changelog = "https://github.com/executablebooks/sphinx-design/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ marsam ];
  };
}
