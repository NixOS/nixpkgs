{ lib
, buildPythonPackage
, fetchPypi
, hatchling
, isPy3k
, backports_functools_lru_cache
}:

buildPythonPackage rec {
  pname = "soupsieve";
  version = "2.3.2.post1";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-/FOJOz2iwz3ilWZ6DhnweMFL+GVErzBzVN5fzxKj8w0=";
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
