{ lib
, buildPythonPackage
, fetchPypi
, isPy3k
, backports_functools_lru_cache
}:

buildPythonPackage rec {
  pname = "soupsieve";
  version = "2.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b8d49b1cd4f037c7082a9683dfa1801aa2597fb11c3a1155b7a5b94829b4f1f9";
  };

  propagatedBuildInputs = lib.optional (!isPy3k) backports_functools_lru_cache;

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
