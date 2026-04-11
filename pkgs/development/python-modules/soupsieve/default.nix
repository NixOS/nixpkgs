{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
}:

buildPythonPackage rec {
  pname = "soupsieve";
  version = "2.8.3";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Mmfx7upCUftCcott+3Ru3JrK/8SkWyfhlFC2dlhug0k=";
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
