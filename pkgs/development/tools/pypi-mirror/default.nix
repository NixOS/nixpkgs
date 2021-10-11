{ fetchFromGitHub
, lib
, python3
}:
python3.pkgs.buildPythonApplication rec {
  pname = "pypi-mirror";
  version = "4.0.7";

  src = fetchFromGitHub {
    owner = "montag451";
    repo = pname;
    rev = "v${version}";
    sha256 = "0sjzjvq2jnsr5mfyvkww3rfk3k5xcl8wa07q614850m0sn907laz";
  };

  pythonImportsCheck = [ "pypi_mirror" ];

  meta = with lib; {
    description = "A script to create a partial PyPI mirror";
    homepage = "https://github.com/montag451/pypi-mirror";
    license = licenses.mit;
    maintainers = with maintainers; [ kamadorueda ];
  };
}
