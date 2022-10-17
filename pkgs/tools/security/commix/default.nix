{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "commix";
  version = "3.5";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "commixproject";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-3UCHTgIW7ArXQD0Kj5XwE1I5VszsueXDJ68QWdQrAho=";
  };

  # Project has no tests
  doCheck = false;

  meta = with lib; {
    description = "Automated Command Injection Exploitation Tool";
    homepage = "https://github.com/commixproject/commix";
    license = with licenses; [ gpl3Plus ];
    maintainers = with maintainers; [ fab ];
  };
}
