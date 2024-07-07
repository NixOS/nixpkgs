{
  lib,
  beautifulsoup4,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pythonOlder,
  pythonRelaxDepsHook,
  rapidfuzz,
  requests,
}:

buildPythonPackage rec {
  pname = "syncedlyrics";
  version = "1.0.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "rtcq";
    repo = "syncedlyrics";
    rev = "refs/tags/v${version}";
    hash = "sha256-W3cg/+nU0Zp5pDhkoHqUemYImlDKlZDVbB7jZ3dScnk=";
  };

  build-system = [
    poetry-core
    pythonRelaxDepsHook
  ];

  pythonRelaxDeps = [ "rapidfuzz" ];

  dependencies = [
    requests
    rapidfuzz
    beautifulsoup4
  ];

  # Tests require network access
  doCheck = false;

  pythonImportsCheck = [ "syncedlyrics" ];

  meta = with lib; {
    description = "Module to get LRC format (synchronized) lyrics";
    homepage = "https://github.com/rtcq/syncedlyrics";
    changelog = "https://github.com/rtcq/syncedlyrics/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
    mainProgram = "syncedlyrics";
  };
}
