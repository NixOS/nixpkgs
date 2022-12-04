{ lib
, buildPythonPackage
, fetchFromGitHub
, sphinx
}:

buildPythonPackage rec {
  pname = "sphinx-copybutton";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "executablebooks";
    repo = "sphinx-copybutton";
    rev = "v${version}";
    sha256 = "sha256-ptQNeklF9f0XeDbBq64ZFV15O8b4lQQLHRfblOQ3nRQ=";
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
