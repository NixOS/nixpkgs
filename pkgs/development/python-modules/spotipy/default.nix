{ lib
, buildPythonPackage
, fetchPypi
, redis
, requests
, six
}:

buildPythonPackage rec {
  pname = "spotipy";
  version = "2.21.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-YhFhqbWqAVaBwu4buIc87i7mtEDYQEDanSpXzWf31eU=";
  };

  propagatedBuildInputs = [
    redis
    requests
    six
  ];

  # tests want to access the spotify API
  doCheck = false;
  pythonImportsCheck = [
    "spotipy"
    "spotipy.oauth2"
  ];

  meta = with lib; {
    homepage = "https://spotipy.readthedocs.org/";
    changelog = "https://github.com/plamere/spotipy/blob/${version}/CHANGELOG.md";
    description = "A light weight Python library for the Spotify Web API";
    license = licenses.mit;
    maintainers = with maintainers; [ rvolosatovs ];
  };
}
