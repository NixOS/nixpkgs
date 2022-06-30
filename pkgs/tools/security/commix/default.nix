{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "commix";
  version = "3.4";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "commixproject";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-JM4NE77LpgsdWhzPe/8K0sQhOSpzDu9usuH7pfQ6dR0=";
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
