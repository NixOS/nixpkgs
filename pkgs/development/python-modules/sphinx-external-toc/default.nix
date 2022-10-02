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
  version = "0.3.0";

  format = "flit";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit version;
    pname = "sphinx_external_toc";
    sha256 = "73198636ada4b4f72f69c7bab09f0e4ce84978056dc5afa9ee51d287bec0a8ef";
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
    license = licenses.mit;
    maintainers = with maintainers; [ marsam ];
  };
}
