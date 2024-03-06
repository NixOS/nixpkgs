{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "past-time";
  version = "0.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "fabaff";
    repo = "past-time";
    rev = "refs/tags/${version}";
    hash = "sha256-3tSEbqGwFw16JcaEERhs6I+BsfxjE1hQWpOT1C+fQDk=";
  };

  nativeBuildInputs = with python3.pkgs; [
    poetry-core
  ];

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
