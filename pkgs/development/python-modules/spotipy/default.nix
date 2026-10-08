{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  redis,
  requests,
  urllib3,
}:

buildPythonPackage (finalAttrs: {
  pname = "spotipy";
  version = "2.26.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    pname = "spotipy";
    inherit (finalAttrs) version;
    hash = "sha256-32ol2CCQcu+ozqFlYI7mRIhOOAT4dittjgbKGlx/imM=";
  };

  build-system = [ setuptools ];

  dependencies = [
    redis
    requests
    urllib3
  ];

  # Tests want to access the spotify API
  doCheck = false;

  pythonImportsCheck = [
    "spotipy"
    "spotipy.oauth2"
  ];

  meta = {
    description = "Library for the Spotify Web API";
    homepage = "https://spotipy.readthedocs.org/";
    changelog = "https://github.com/plamere/spotipy/blob/${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ rvolosatovs ];
  };
})
