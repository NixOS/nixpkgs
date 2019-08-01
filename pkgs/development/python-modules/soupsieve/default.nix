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
  version = "1.9.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "14hs982wbb0rshnfiwjzda2zv6pcxcdr4bsfxjfpgn5qcqrq8ql6";
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
