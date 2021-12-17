{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "wasabi";
  version = "0.9.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "152245d892030a3a7b511038e9472acff6d0e237cfe4123fef0d147f2d3274fc";
  };

  checkInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "A lightweight console printing and formatting toolkit";
    homepage = "https://github.com/ines/wasabi";
    changelog = "https://github.com/ines/wasabi/releases/tag/v${version}";
    license = licenses.mit;
  };
}
