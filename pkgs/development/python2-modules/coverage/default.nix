{ lib
, buildPythonPackage
, fetchPypi
, mock
}:

buildPythonPackage rec {
  pname = "coverage";
  version = "5.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ebe78fe9a0e874362175b02371bdfbee64d8edc42a044253ddf4ee7d3c15212c";
  };

  # No tests in archive
  doCheck = false;
  checkInputs = [ mock ];

  meta = {
    description = "Code coverage measurement for python";
    homepage = "https://coverage.readthedocs.io/";
    license = lib.licenses.bsd3;
  };
}
