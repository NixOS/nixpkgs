{ lib
, buildPythonPackage
, fetchPypi
, wrapio
}:

buildPythonPackage rec {
  pname = "survey";
  version = "3.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-R/PfXW/CnqYiOWbCxPAYwneg6j6CLvdIpITZ2eIXn+M=";
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
