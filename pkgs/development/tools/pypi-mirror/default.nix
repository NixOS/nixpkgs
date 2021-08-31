{ fetchFromGitHub
, lib
, python3
}:
python3.pkgs.buildPythonApplication rec {
  pname = "pypi-mirror";
  version = "4.0.6";

  src = fetchFromGitHub {
    owner = "montag451";
    repo = pname;
    rev = "v${version}";
    sha256 = "0slh8ahywcgbggfcmzyqpb8bmq9dkk6vvjfkbi0ashnm8c6x19vd";
  };

  pythonImportsCheck = [ "pypi_mirror" ];

  meta = with lib; {
    description = "A script to create a partial PyPI mirror";
    homepage = "https://github.com/montag451/pypi-mirror";
    license = licenses.mit;
    maintainers = with maintainers; [ kamadorueda ];
  };
}
