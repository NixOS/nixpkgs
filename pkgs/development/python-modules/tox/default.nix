{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  packaging,
  pluggy,
  virtualenv,
  tomli,
  filelock,
  hatchling,
  hatch-vcs,
  platformdirs,
  pyproject-api,
  colorama,
  chardet,
  cachetools,
  testers,
  tox,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "tox";
  version = "4.34.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tox-dev";
    repo = "tox";
    tag = version;
    hash = "sha256-pfftPTY7n47tCQFGCZRwsq0vCWZUeukFZO99gj5mTeo=";
  };

  build-system = [
    hatchling
    hatch-vcs
  ];

  dependencies = [
    cachetools
    chardet
    colorama
    filelock
    packaging
    platformdirs
    pluggy
    pyproject-api
    virtualenv
  ]
  ++ lib.optionals (pythonOlder "3.11") [
    tomli
    typing-extensions
  ];

  doCheck = false; # infinite recursion via devpi-client

  passthru.tests = {
    version = testers.testVersion { package = tox; };
  };

  meta = {
    changelog = "https://github.com/tox-dev/tox/releases/tag/${src.tag}";
    description = "Generic virtualenv management and test command line tool";
    mainProgram = "tox";
    homepage = "https://github.com/tox-dev/tox";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
