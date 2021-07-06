{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, wrapio
}:

buildPythonPackage rec {
  pname = "survey";
  version = "3.4.3";

  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-TK89quY3bpNIEz1n3Ecew4FnTH6QgeSLdDNV86gq7+I=";
  };

  propagatedBuildInputs = [
    wrapio
  ];

  doCheck = false;
  pythonImportsCheck = [ "survey" ];

  meta = with lib; {
    homepage = "https://github.com/Exahilosys/survey";
    description = "A simple library for creating beautiful interactive prompts";
    license = licenses.mit;
    maintainers = with maintainers; [ sfrijters ];
  };
}
