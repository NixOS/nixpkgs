{ fetchFromGitHub
, lib
, python3
}:
python3.pkgs.buildPythonApplication rec {
  pname = "pypi-mirror";
  version = "5.0.2";

  src = fetchFromGitHub {
    owner = "montag451";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-AqE3lAcqWq5CGsgwm8jLa1wX93deFC4mKn+oaVhO508=";
  };

  pythonImportsCheck = [ "pypi_mirror" ];

  meta = with lib; {
    description = "A script to create a partial PyPI mirror";
    homepage = "https://github.com/montag451/pypi-mirror";
    license = licenses.mit;
    maintainers = with maintainers; [ kamadorueda ];
  };
}
