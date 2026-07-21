{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  lxml,
  twisted,
  python3-application,
  unstableGitUpdater,
}:

buildPythonPackage {
  pname = "xcaplib";
  # latest commit is needed for python 3.13 compat.
  version = "2.0.2-unstable-2026-07-09";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "AGProjects";
    repo = "python3-xcaplib";
    rev = "73cc7f405f2a10fd113b5cbbc80e4b3fc5537236";
    hash = "sha256-67go56VUKbZOyaofpurfN50acpzBrzzmjrGqh7mUKZg=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    lxml
    twisted
    python3-application
  ];

  # the one and only upstream test relies on networking
  doCheck = false;

  pythonImportsCheck = [ "xcaplib" ];

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "XCAP (RFC4825) client library";
    homepage = "https://github.com/AGProjects/python3-xcaplib";
    license = lib.licenses.lgpl21Plus;
    teams = [ lib.teams.ngi ];
    maintainers = [ lib.maintainers.ethancedwards8 ];
    mainProgram = "xcapclient3";
  };
}
