{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
}:

buildPythonPackage rec {
  pname = "soupsieve";
  version = "2.6";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-4uaEF3d681nsZdqsEFdASjyKVFW7irw28amGarGlGrs=";
  };

  nativeBuildInputs = [ hatchling ];

  # Circular dependency on beautifulsoup4
  doCheck = false;

  # Circular dependency on beautifulsoup4
  # pythonImportsCheck = [ "soupsieve" ];

  meta = with lib; {
    description = "CSS4 selector implementation for Beautiful Soup";
    license = licenses.mit;
    homepage = "https://github.com/facelessuser/soupsieve";
    maintainers = [ ];
  };
}
