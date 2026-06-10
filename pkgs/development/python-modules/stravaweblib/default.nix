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

buildPythonPackage (finalAttrs: {
  pname = "stravaweblib";
  version = "0.0.10";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "pR0Ps";
    repo = "stravaweblib";
    tag = "v${finalAttrs.version}";
    hash = "sha256-hsXrU7Rad3LzF58GwlgET98911XjTKztFFNqiUSw278=";
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
})
