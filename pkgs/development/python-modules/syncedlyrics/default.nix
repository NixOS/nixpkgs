{ lib
, beautifulsoup4
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pythonOlder
, pythonRelaxDepsHook
, rapidfuzz
, requests
}:

buildPythonPackage rec {
  pname = "syncedlyrics";
  version = "0.8.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "rtcq";
    repo = "syncedlyrics";
    rev = "refs/tags/v${version}";
    hash = "sha256-ro9HzI8N7Ry4xh91mO1Vyy3CScEi3FifweOO01/Ti0w=";
  };

  nativeBuildInputs = [
    poetry-core
    pythonRelaxDepsHook
  ];

  pythonRelaxDeps = [
    "rapidfuzz"
  ];

  propagatedBuildInputs = [
    requests
    rapidfuzz
    beautifulsoup4
  ];

  # Tests require network access
  doCheck = false;

  pythonImportsCheck = [
    "syncedlyrics"
  ];

  meta = with lib; {
    description = "Module to get LRC format (synchronized) lyrics";
    homepage = "https://github.com/rtcq/syncedlyrics";
    changelog = "https://github.com/rtcq/syncedlyrics/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
