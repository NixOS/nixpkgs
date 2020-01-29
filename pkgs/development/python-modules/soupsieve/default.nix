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
  version = "1.9.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e2c1c5dee4a1c36bcb790e0fabd5492d874b8ebd4617622c4f6a731701060dda";
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
    homepage = https://github.com/facelessuser/soupsieve;
  };

}