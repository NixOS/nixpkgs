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
  version = "1.7.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "87db12ae79194f0ff9808d2b1641c4f031ae39ffa3cab6b907ea7c1e5e5ed445";
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