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
  version = "2.0.2-unstable-2026-01-23";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "AGProjects";
    repo = "python3-xcaplib";
    rev = "2bdce48bcec6c80618da1b04cd9a437297993e56";
    hash = "sha256-/htvXj9rLlJxcgJoUh4OG8PcCVIJ46ghzzqLZicONVc=";
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
