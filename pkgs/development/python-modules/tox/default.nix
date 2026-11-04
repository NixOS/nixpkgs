{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  packaging,
  pluggy,
  virtualenv,
  docutils,
  filelock,
  hatch-fancy-pypi-readme,
  hatchling,
  hatch-vcs,
  platformdirs,
  pyproject-api,
  tomli-w,
  colorama,
  chardet,
  cachetools,
  testers,
  tox,
}:

buildPythonPackage rec {
  pname = "tox";
  version = "4.67.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tox-dev";
    repo = "tox";
    tag = version;
    hash = "sha256-WdJDte3cSYCn2unnJNZ1gDe74ma8gYBgIZT+4jpFI6E=";
  };

  build-system = [
    docutils
    hatch-fancy-pypi-readme
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
    tomli-w
    virtualenv
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
