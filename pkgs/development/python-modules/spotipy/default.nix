{ lib
, buildPythonPackage
, fetchPypi
, requests
, six }:

buildPythonPackage rec {
  pname = "spotipy";
  version = "2.17.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "29c60c8b99da1c4b9f0d722169bc31e624b8c07d7186b8eadd9c02e8d2d42cbf";
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
