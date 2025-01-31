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
  version = "0.0.8";

  src = fetchFromGitHub {
    owner = "pR0Ps";
    repo = "stravaweblib";
    rev = "refs/tags/v${version}";
    hash = "sha256-v54UeRjhoH0GN2AVFKRjqKJ6BYUXVATe2qoDk9P48oU=";
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
