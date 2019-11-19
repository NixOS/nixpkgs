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
  version = "1.9.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "605f89ad5fdbfefe30cdc293303665eff2d188865d4dbe4eb510bba1edfbfce3";
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