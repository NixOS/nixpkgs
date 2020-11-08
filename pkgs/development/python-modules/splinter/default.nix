{ lib
, buildPythonPackage
, fetchPypi
, selenium
, flask
, coverage
}:

buildPythonPackage rec {
  pname = "splinter";
  version = "0.14.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "459e39e7a9f7572db6f1cdb5fdc5ccfc6404f021dccb969ee6287be2386a40db";
  };

  requiredPythonModules = [ selenium ];

  checkInputs = [ flask coverage ];

  # No tests included
  doCheck = false;

  meta = {
    description = "Browser abstraction for web acceptance testing";
    homepage = "https://github.com/cobrateam/splinter";
    license = lib.licenses.bsd3;
  };
}
