{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "time-decode";
  version = "4.1.2";

  src = fetchFromGitHub {
    owner = "digitalsleuth";
    repo = "time_decode";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-79TReAEHvLldp0n3jTvws3mFE/1O1h6TocjMHrurwt4=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    colorama
    python-dateutil
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "time_decode" ];

  meta = with lib; {
    description = "Timestamp and date decoder";
    homepage = "https://github.com/digitalsleuth/time_decode";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
