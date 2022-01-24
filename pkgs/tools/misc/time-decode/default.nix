{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "time-decode";
  version = "3.2.0";

  src = fetchFromGitHub {
    owner = "digitalsleuth";
    repo = "time_decode";
    rev = "v${version}";
    sha256 = "1iwqdq1ail04hs8pkb6rxan4ng2jl2iar6pk72skj41xh4qhlyg6";
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
