{ lib
, buildPythonApplication
, fetchFromGitHub
, aiodns
, click
, tqdm
, uvloop
}:

buildPythonApplication rec {
  pname = "aiodnsbrute";
  version = "0.3.3";

  src = fetchFromGitHub {
    owner = "blark";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-cEpk71VoQJZfKeAZummkk7yjtXKSMndgo0VleYiMlWE=";
  };

  # https://github.com/blark/aiodnsbrute/pull/8
  prePatch = ''
    substituteInPlace setup.py --replace " 'asyncio', " ""
  '';

  propagatedBuildInputs = [
     aiodns
     click
     tqdm
     uvloop
  ];

  # no tests present
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
