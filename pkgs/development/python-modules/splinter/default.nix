{ lib
, buildPythonPackage
, fetchPypi
, selenium
, flask
, coverage
}:

buildPythonPackage rec {
  pname = "splinter";
  version = "0.8.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "463e98135a85ff98f6c0084cb34cea1fe07827444958d224c087a84093a65281";
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