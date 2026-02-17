{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  packaging,
  pluggy,
  virtualenv,
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
}:

buildPythonPackage rec {
  pname = "tox";
  version = "4.32.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tox-dev";
    repo = "tox";
    tag = version;
    hash = "sha256-n2tKjT0t8bm6iatukKKcGw0PC+5EJrQEABMIAumRaqE=";
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
