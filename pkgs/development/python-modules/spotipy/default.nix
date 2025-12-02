{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  redis,
  requests,
  urllib3,
}:

buildPythonPackage rec {
  pname = "spotipy";
  version = "2.25.2";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-XtRcBEFWylUYmX4lArHyweczZAfLH7j+ES0US01Sgsg=";
  };

  propagatedBuildInputs = [
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

  meta = with lib; {
    description = "Library for the Spotify Web API";
    homepage = "https://spotipy.readthedocs.org/";
    changelog = "https://github.com/plamere/spotipy/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ rvolosatovs ];
  };
}
