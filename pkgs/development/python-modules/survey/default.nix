{ lib
, buildPythonPackage
, fetchPypi
, wrapio
}:

buildPythonPackage rec {
  pname = "survey";
  version = "3.4.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-aF7ZS5oxeIOb7mJsrusdc3HefcPE+3OTXcJB/pjJxFY=";
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
