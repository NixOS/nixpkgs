{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
}:

buildPythonPackage rec {
  pname = "soupsieve";
  version = "2.7";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-rSgvm2kmKG0urUdQVSyKYUK8THg/1msCk1R8j+auEmo=";
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
