{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  nix-update-script,

  # setuptools
  setuptools,
  setuptools-scm,

  # dependencies
  stravalib,
  beautifulsoup4,
}:

buildPythonPackage rec {
  pname = "stravaweblib";
  version = "0.0.9";

  src = fetchFromGitHub {
    owner = "pR0Ps";
    repo = "stravaweblib";
    tag = "v${version}";
    hash = "sha256-bKiQ06vQfngELuREje9KQd5JNl6gaoU5jvGOyj3Wyb0=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    stravalib
    beautifulsoup4
  ];

  pythonImportsCheck = [ "stravaweblib" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Python library for extending the Strava v3 API using web scraping";
    homepage = "https://github.com/pR0Ps/stravaweblib";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ stv0g ];
  };
}
