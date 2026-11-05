{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
}:

buildPythonPackage rec {
  pname = "soupsieve";
  version = "4.0.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-diHjxfazce0sXquqxd4wCsPWbQXm1/NHg+MbY8T5DHU=";
  };

  nativeBuildInputs = [ hatchling ];

  # Circular dependency on beautifulsoup4
  doCheck = false;

  # Circular dependency on beautifulsoup4
  # pythonImportsCheck = [ "soupsieve" ];

  meta = {
    description = "CSS4 selector implementation for Beautiful Soup";
    license = lib.licenses.mit;
    homepage = "https://github.com/facelessuser/soupsieve";
    maintainers = [ ];
  };
}
