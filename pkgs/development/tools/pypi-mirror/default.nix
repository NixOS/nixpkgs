{ fetchFromGitHub
, lib
, python3
}:
python3.pkgs.buildPythonApplication rec {
  pname = "pypi-mirror";
  version = "4.1.0";

  src = fetchFromGitHub {
    owner = "montag451";
    repo = pname;
    rev = "v${version}";
    sha256 = "077f3asi5fdbb2j2ll4xdwv7ndfbfr81bpn3zi55h6idfdc7zzc0";
  };

  pythonImportsCheck = [ "pypi_mirror" ];

  meta = with lib; {
    description = "A script to create a partial PyPI mirror";
    homepage = "https://github.com/montag451/pypi-mirror";
    license = licenses.mit;
    maintainers = with maintainers; [ kamadorueda ];
  };
}
