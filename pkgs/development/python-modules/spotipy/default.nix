{ lib
, buildPythonPackage
, fetchPypi
, redis
, requests
, six
}:

buildPythonPackage rec {
  pname = "spotipy";
  version = "2.20.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-4mqZt1vi/EI3WytLNV3ET6Hlnvx3OvoXt4ThpMCoGMk=";
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
