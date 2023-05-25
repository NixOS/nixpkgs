{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, flit-core
, sphinx
}:

buildPythonPackage rec {
  pname = "sphinx-design";
  version = "0.4.1";

  format = "flit";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit version;
    pname = "sphinx_design";
    hash = "sha256-W2QYukotw9g1kuoP9hpSqJH+chlaTDoYsvocdmjORwg=";
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
