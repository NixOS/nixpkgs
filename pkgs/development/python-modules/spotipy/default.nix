{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, redis
, requests
, six
, urllib3
}:

buildPythonPackage rec {
  pname = "spotipy";
  version = "2.23.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Dfr+CCOdqubBb6po9gtXddQMQRByXhp8VFrUx/tm1Og=";
  };

  propagatedBuildInputs = [
    redis
    requests
    six
    urllib3
  ];

  # Tests want to access the spotify API
  doCheck = false;

  pythonImportsCheck = [
    "spotipy"
    "spotipy.oauth2"
  ];

  meta = with lib; {
    description = "Library for the Spotify Web API";
    homepage = "https://spotipy.readthedocs.org/";
    changelog = "https://github.com/plamere/spotipy/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ rvolosatovs ];
  };
}
