{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  requests,
  unstableGitUpdater,
}:

buildPythonPackage {
  pname = "tmdbsimple";
  version = "2.9.6-unstable-2026-05-25";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "celiao";
    repo = "tmdbsimple";
    rev = "e17ec769c5ec6a465b9e10889bc7c9ab9746bf27";
    hash = "sha256-ooyfwRCvH980gym8ujpLxbmR7FYfi59gGXqT8K40pNw=";
  };

  build-system = [ setuptools ];

  dependencies = [ requests ];

  pythonImportsCheck = [ "tmdbsimple" ];

  # The tests require an internet connection and an API key
  doCheck = false;

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Wrapper for The Movie Database API v3";
    homepage = "https://github.com/celiao/tmdbsimple";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ theobori ];
  };
}
