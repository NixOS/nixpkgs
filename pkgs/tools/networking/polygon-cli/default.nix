{ lib
, python3
, fetchPypi
}:

python3.pkgs.buildPythonPackage rec {
  pname = "polygon-cli";
  version = "1.1.11";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-gEz3kcXbXj9dXnMCx0Q8TjCQemXvJne9EwFsPt14xV4=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    setuptools
    requests
    prettytable
    colorama
    pyyaml
  ];

  doCheck = false;

  meta = {
    description = "Command-line tool for polygon.codeforces.com";
    mainProgram = "polygon-cli";
    homepage = "https://github.com/kunyavskiy/polygon-cli";
    changelog = "https://github.com/kunyavskiy/polygon-cli/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaser ];
  };
}
