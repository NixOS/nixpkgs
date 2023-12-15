{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, flit-core
, click
, pyyaml
, sphinx
}:

buildPythonPackage rec {
  pname = "sphinx-external-toc";
  version = "1.0.0";

  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit version;
    pname = "sphinx_external_toc";
    sha256 = "sha256-990JX/OrD7dKMQ1BCwo2GPwd3G8s5DWJfWWayqSj6yQ=";
  };

  nativeBuildInputs = [ flit-core ];

  propagatedBuildInputs = [
    click
    pyyaml
    sphinx
  ];

  pythonImportsCheck = [ "sphinx_external_toc" ];

  meta = with lib; {
    description = "A sphinx extension that allows the site-map to be defined in a single YAML file";
    homepage = "https://github.com/executablebooks/sphinx-external-toc";
    changelog = "https://github.com/executablebooks/sphinx-external-toc/raw/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ marsam ];
  };
}
