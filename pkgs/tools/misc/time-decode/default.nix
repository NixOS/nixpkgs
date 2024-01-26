{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "time-decode";
  version = "6.1.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "digitalsleuth";
    repo = "time_decode";
    rev = "refs/tags/v${version}";
    hash = "sha256-LbXycu3Yiku9ToW+WS/yUqwicvckj2IkP09TiZkRXnk=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    colorama
    python-dateutil
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [
    "time_decode"
  ];

  meta = with lib; {
    description = "Timestamp and date decoder";
    homepage = "https://github.com/digitalsleuth/time_decode";
    changelog = "https://github.com/digitalsleuth/time_decode/releases/tag/v${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
    mainProgram = "time-decode";
  };
}
