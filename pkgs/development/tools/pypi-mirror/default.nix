{ fetchFromGitHub
, lib
, python3
}:
python3.pkgs.buildPythonApplication rec {
  pname = "pypi-mirror";
  version = "5.0.1";

  src = fetchFromGitHub {
    owner = "montag451";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-x0to3VrnuON1Ghj6LlMOjJfqSVh9eF3Yg6Cdcxtpbc8=";
  };

  pythonImportsCheck = [ "pypi_mirror" ];

  meta = with lib; {
    description = "A script to create a partial PyPI mirror";
    homepage = "https://github.com/montag451/pypi-mirror";
    license = licenses.mit;
    maintainers = with maintainers; [ kamadorueda ];
  };
}
