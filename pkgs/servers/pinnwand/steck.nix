{ lib, pkgs, python3Packages, nixosTests }:

python3Packages.buildPythonApplication rec {
  pname = "steck";
  version = "0.6.0";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "07gc5iwbyprb8nihnjjl2zd06z8p4nl3a3drzh9a8ny35ig1khq0";
  };

  propagatedBuildInputs = with python3Packages; [
    pkgs.git
    appdirs
    click
    python_magic
    requests
    termcolor
    toml
  ];

  passthru.tests = nixosTests.pinnwand;

  meta = with lib; {
    homepage = "https://github.com/supakeen/steck";
    license = licenses.mit;
    description = "Client for pinnwand pastebin.";
    maintainers = with maintainers; [ hexa ];
  };
}

