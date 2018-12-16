{ lib
, buildPythonPackage
, fetchPypi
, selenium
, flask
, coverage
}:

buildPythonPackage rec {
  pname = "splinter";
  version = "0.10.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1x5g7pfj813rnci7dc46y01bq24qzw5qwlzm4iw61hg66q2kg7rd";
  };

  propagatedBuildInputs = [ selenium ];

  checkInputs = [ flask coverage ];

  # No tests included
  doCheck = false;

  meta = {
    description = "Browser abstraction for web acceptance testing";
    homepage = https://github.com/cobrateam/splinter;
    license = lib.licenses.bsd3;
  };
}