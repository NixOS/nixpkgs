{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, wrapio
}:

buildPythonPackage rec {
  pname = "survey";
  version = "4.4.0";

  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-5pesfVIUA0+po8a9MggowZu+UVtZv9hbZHwxMSuZhRg=";
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
