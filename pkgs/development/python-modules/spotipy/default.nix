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
  version = "2.25.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-xycg74U1Wv+Vn3/o2J3tSFBNjDO5JYPbkOwW2qwNpU8=";
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
