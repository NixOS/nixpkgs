{ lib
, buildPythonPackage
, fetchPypi
, hatch-vcs
, hatchling
, pythonOlder
, sphinx
}:

buildPythonPackage rec {
  pname = "sphinx-thebe";
  version = "0.3.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit version;
    pname = "sphinx_thebe";
    hash = "sha256-xg2rG1m5LWouq41xGeh8BzBHDaYvPIS/bKdWkEh9BQU=";
  };

  nativeBuildInputs = [
    hatch-vcs
    hatchling
  ];

  propagatedBuildInputs = [
    sphinx
  ];

  pythonImportsCheck = [
    "sphinx_thebe"
  ];

  meta = with lib; {
    description = "Integrate interactive code blocks into your documentation with Thebe and Binder";
    homepage = "https://github.com/executablebooks/sphinx-thebe";
    changelog = "https://github.com/executablebooks/sphinx-thebe/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ marsam ];
  };
}
