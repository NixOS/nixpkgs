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
    hash = "sha256-TK89quY3bpNIEz1n3Ecew4FnTH6QgeSLdDNV86gq7+I=";
  };

  propagatedBuildInputs = [
    wrapio
  ];

  doCheck = false;
  pythonImportsCheck = [ "survey" ];

  meta = with lib; {
    description = "A simple library for creating beautiful interactive prompts";
    homepage = "https://github.com/Exahilosys/survey";
    changelog = "https://github.com/Exahilosys/survey/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ sfrijters ];
  };
}
