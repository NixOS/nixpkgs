{ lib, stdenv
, buildPythonPackage
, fetchPypi
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "wasabi";
  version = "0.8.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "75fec6db6193c8615d7f398ae4aa2c4ad294e6e3e81c6a6dbbbd3864ee2223c3";
  };

  checkInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "A lightweight console printing and formatting toolkit";
    homepage = "https://github.com/ines/wasabi";
    changelog = "https://github.com/ines/wasabi/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ danieldk ];
  };
}
