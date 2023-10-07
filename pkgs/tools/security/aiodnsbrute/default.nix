{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "aiodnsbrute";
  version = "0.3.3";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "blark";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-cEpk71VoQJZfKeAZummkk7yjtXKSMndgo0VleYiMlWE=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    aiodns
    click
    tqdm
    uvloop
  ];

  # Project no tests
  doCheck = false;

  pythonImportsCheck = [
    "aiodnsbrute.cli"
  ];

  meta = with lib; {
    description = "DNS brute force utility";
    homepage = "https://github.com/blark/aiodnsbrute";
    changelog = "https://github.com/blark/aiodnsbrute/releases/tag/v${version}";
    license = with licenses; [ gpl3Only ];
    maintainers = with maintainers; [ fab ];
  };
}
