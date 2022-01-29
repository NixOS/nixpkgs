{ fetchFromGitHub
, lib
, python3
}:
python3.pkgs.buildPythonApplication rec {
  pname = "pypi-mirror";
  version = "4.2.0";

  src = fetchFromGitHub {
    owner = "montag451";
    repo = pname;
    rev = "v${version}";
    sha256 = "1ci19bqyhig1s5myzw6klkiycd8k0lzhk3yqfx5fjirc2f0xpz5j";
  };

  pythonImportsCheck = [ "pypi_mirror" ];

  meta = with lib; {
    description = "A script to create a partial PyPI mirror";
    homepage = "https://github.com/montag451/pypi-mirror";
    license = licenses.mit;
    maintainers = with maintainers; [ kamadorueda ];
  };
}
