{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "past-time";
  version = "0.2.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "fabaff";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-9LmFOWNUkvKfWHLo4HB1W1UBQL90Gp9UJJ3VDIYBDHo=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    click
    tqdm
  ];

  nativeCheckInputs = with python3.pkgs; [
    freezegun
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "past_time"
  ];

  meta = with lib; {
    description = "Tool to visualize the progress of the year based on the past days";
    homepage = "https://github.com/fabaff/past-time";
    changelog = "https://github.com/fabaff/past-time/releases/tag/${version}";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
    mainProgram = "past-time";
  };
}
