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

buildPythonPackage rec {
  pname = "xcaplib";
  # latest commit is needed for python 3.13 compat.
  version = "2.0.1-unstable-2025-03-20";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "AGProjects";
    repo = "python3-xcaplib";
    rev = "925846f2520d823f0b83279ceca6202808a4ca4f";
    hash = "sha256-8EtXwHMQcPzPfP8JpB6gTV7PADHz+bJIJMhvR3DkPkk=";
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
