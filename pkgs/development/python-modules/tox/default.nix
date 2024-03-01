{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, packaging
, pluggy
, py
, six
, virtualenv
, setuptools-scm
, toml
, tomli
, filelock
, hatchling
, hatch-vcs
, platformdirs
, pyproject-api
, colorama
, chardet
, cachetools
, testers
, tox
}:

buildPythonPackage rec {
  pname = "tox";
  version = "4.11.4";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "tox-dev";
    repo = "tox";
    rev = "refs/tags/${version}";
    hash = "sha256-pZmT8392YuHzCrAquPpveByYw3x6bkMGCUToCAqAGc8=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "packaging>=22" "packaging"
  '';

  nativeBuildInputs = [
    hatchling
    hatch-vcs
  ];

  propagatedBuildInputs = [
    cachetools
    chardet
    colorama
    filelock
    packaging
    platformdirs
    pluggy
    py
    pyproject-api
    six
    toml
    virtualenv
  ]  ++ lib.optionals (pythonOlder "3.11") [
    tomli
  ];

  doCheck = false; # infinite recursion via devpi-client

  passthru.tests = {
    version = testers.testVersion { package = tox; };
  };

  meta = with lib; {
    changelog = "https://github.com/tox-dev/tox/releases/tag/${version}";
    description = "A generic virtualenv management and test command line tool";
    homepage = "https://github.com/tox-dev/tox";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
