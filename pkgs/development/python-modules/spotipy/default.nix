{ lib
, buildPythonPackage
, fetchPypi
, requests
, six }:

buildPythonPackage rec {
  pname = "spotipy";
  version = "2.19.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-kE9ugT26g3dY6VEMG+5R18ohfxaSRmJaE+aTcz3DNUM=";
  };

  propagatedBuildInputs = [ requests six ];

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
