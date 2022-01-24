{ lib
, buildPythonPackage
, fetchPypi
, pytest
, beautifulsoup4
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

  checkPhase = ''
    py.test
  '';

  checkInputs = [ pytest beautifulsoup4 ];

  propagatedBuildInputs = lib.optional (!isPy3k) backports_functools_lru_cache;

  # Circular test dependency on beautifulsoup4
  doCheck = false;

  meta = {
    description = "A CSS4 selector implementation for Beautiful Soup";
    license = lib.licenses.mit;
    homepage = "https://github.com/facelessuser/soupsieve";
  };

}
