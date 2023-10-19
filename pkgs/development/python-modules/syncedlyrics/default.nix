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
  version = "0.6.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "rtcq";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-oMG3TqCJfEyfF5zK8hNhyhQ1z7G+S+De8hI1GLCfctM=";
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
