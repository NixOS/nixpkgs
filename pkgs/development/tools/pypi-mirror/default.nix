{ fetchFromGitHub
, lib
, python3
}:
python3.pkgs.buildPythonApplication rec {
  pname = "pypi-mirror";
  version = "5.2.1";

  src = fetchFromGitHub {
    owner = "montag451";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-hRqQDYgOKpv4jmNvyrt/+EInPM/Xwsr3IjtrySAGRgY=";
  };

  pythonImportsCheck = [ "pypi_mirror" ];

  meta = with lib; {
    description = "Script to create a partial PyPI mirror";
    mainProgram = "pypi-mirror";
    homepage = "https://github.com/montag451/pypi-mirror";
    license = licenses.mit;
    maintainers = with maintainers; [ kamadorueda ];
  };
}
