{ lib
, buildPythonPackage
, fetchPypi
, hatchling
, isPy3k
, backports_functools_lru_cache
}:

buildPythonPackage rec {
  pname = "soupsieve";
  version = "2.4";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-4o26nKbHwAFz405LpXRI8GiLtoG3xei/SXHar8CT1po=";
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
