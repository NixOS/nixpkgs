{ lib
, fetchFromGitHub
, python3
}:

with python3.pkgs; buildPythonApplication rec {
  pname = "poetry2conda";
  version = "0.3.0";

  format = "pyproject";

  src = fetchFromGitHub {
    owner = "dojeda";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-UqNoEGgStvqtxhYwExk7wO4SvATaM2kGaFbB5ViJa7U=";
  };

  nativeBuildInputs = [ poetry ];

  propagatedBuildInputs = [
    poetry-semver
    toml
  ];

  checkInputs = [
    pytest-mock
    pytestCheckHook
    pyyaml
  ];

  meta = with lib; {
    description = "A script to convert a Python project declared on a pyproject.toml to a conda environment";
    homepage = "https://github.com/dojeda/poetry2conda";
    license = licenses.mit;
    maintainers = with maintainers; [ cpcloud ];
  };
}
