{ lib
, buildPythonPackage
, fetchPypi
, hatchling
, isPy3k
}:

buildPythonPackage rec {
  pname = "soupsieve";
  version = "2.5";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-VmPVp7O/ru4LxDcuf8SPnP9JQLPuxUpkUcxSmfEJdpA=";
  };

  nativeBuildInputs = [
    hatchling
  ];

  # Circular dependency on beautifulsoup4
  doCheck = false;

  # Circular dependency on beautifulsoup4
  # pythonImportsCheck = [ "soupsieve" ];

  meta = with lib; {
    description = "A CSS4 selector implementation for Beautiful Soup";
    license = licenses.mit;
    homepage = "https://github.com/facelessuser/soupsieve";
    maintainers = with maintainers; [ ];
  };
}
