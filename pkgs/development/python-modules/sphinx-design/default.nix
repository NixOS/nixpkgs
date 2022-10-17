{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, flit-core
, sphinx
}:

buildPythonPackage rec {
  pname = "sphinx-design";
  version = "0.3.0";

  format = "flit";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit version;
    pname = "sphinx_design";
    sha256 = "sha256-cYP6H65Vs37wG9pRJaIe6EH1u8v1mjU4K+WYGAxM77o=";
  };

  nativeBuildInputs = [ flit-core ];

  propagatedBuildInputs = [ sphinx ];

  pythonImportsCheck = [ "sphinx_design" ];

  meta = with lib; {
    description = "A sphinx extension for designing beautiful, view size responsive web components";
    homepage = "https://github.com/executablebooks/sphinx-design";
    license = licenses.mit;
    maintainers = with maintainers; [ marsam ];
  };
}
