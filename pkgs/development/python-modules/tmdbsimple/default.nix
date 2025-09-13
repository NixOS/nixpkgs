{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  requests,
}:

buildPythonPackage {
  pname = "tmdbsimple";
  version = "2.9.2-unstable-2025-01-07";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "celiao";
    repo = "tmdbsimple";
    rev = "0b3359f7bab3ade391b2e5de964ed115b00984a6";
    hash = "sha256-usyL2lHSJwvPnWncI3K+yTmeU5DN1AkRzHC5nFh3vxs=";
  };

  build-system = [ setuptools ];

  dependencies = [ requests ];

  pythonImportsCheck = [ "tmdbsimple" ];

  # The tests require an internet connection and an API key
  doCheck = false;

  meta = {
    description = "Wrapper for The Movie Database API v3";
    homepage = "https://github.com/celiao/tmdbsimple";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ theobori ];
  };
}
