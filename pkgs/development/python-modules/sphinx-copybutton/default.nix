{ lib
, buildPythonPackage
, fetchFromGitHub
, sphinx
}:

buildPythonPackage rec {
  pname = "sphinx-copybutton";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "executablebooks";
    repo = "sphinx-copybutton";
    rev = "v${version}";
    sha256 = "sha256-W27kCU/8NHoBtiAyA+CgNa00j6ck3CAaq1hLLGo60Ro=";
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
