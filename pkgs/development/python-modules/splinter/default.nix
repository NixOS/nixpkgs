{ lib
, buildPythonPackage
, fetchPypi
, selenium
, flask
, coverage
}:

buildPythonPackage rec {
  pname = "splinter";
  version = "0.11.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0ddv80dv54rraa18lg9v7m9z61wzfwv6ww9ld83mr32gy3a2238p";
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