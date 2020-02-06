{ lib
, buildPythonPackage
, fetchPypi
, selenium
, flask
, coverage
}:

buildPythonPackage rec {
  pname = "splinter";
  version = "0.13.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9e92535f273622507ac157612c3bb0e9cee7b5ccd2aa097d47b408e34c2ca356";
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