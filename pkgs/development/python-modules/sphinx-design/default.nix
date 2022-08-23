{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, flit-core
, sphinx
}:

buildPythonPackage rec {
  pname = "sphinx-design";
  version = "0.2.0";

  format = "flit";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit version;
    pname = "sphinx_design";
    sha256 = "b148a5258061a46ee826d57ea0729260f29b4e9131d2a681545e0d4f3c0f19ee";
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
