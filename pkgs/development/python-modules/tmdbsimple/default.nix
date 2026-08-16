{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  requests,
}:

buildPythonPackage (finalAttrs: {
  pname = "tmdbsimple";
  version = "2.9.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "celiao";
    repo = "tmdbsimple";
    tag = finalAttrs.version;
    hash = "sha256-bKSvknFnqF/QXdJZfQu6RCufXp6u4zvr8IAo8WToWf8=";
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
})
