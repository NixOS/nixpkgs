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
  version = "0.3.1";

  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit version;
    pname = "sphinx_external_toc";
    sha256 = "9c8ea9980ea0e57bf3ce98f6a400f9b69eb1df808f7dd796c9c8cc1873d8b355";
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
