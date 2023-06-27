{ lib
, buildPythonPackage
, fetchFromGitHub
, sphinx
}:

buildPythonPackage rec {
  pname = "sphinx-copybutton";
  version = "0.5.2";

  src = fetchFromGitHub {
    owner = "executablebooks";
    repo = "sphinx-copybutton";
    rev = "v${version}";
    hash = "sha256-LM2LtQuYsPRJ2XX9aAW36xRtwghTkzug6A6fpVJ6hbk=";
    fetchSubmodules = true;
  };

  propagatedBuildInputs = [
    sphinx
  ];

  doCheck = false; # no tests

  pythonImportsCheck = [ "sphinx_copybutton" ];

  meta = with lib; {
    description = "A small sphinx extension to add a \"copy\" button to code blocks";
    homepage = "https://github.com/executablebooks/sphinx-copybutton";
    license = licenses.mit;
    maintainers = with maintainers; [ Luflosi ];
  };
}
