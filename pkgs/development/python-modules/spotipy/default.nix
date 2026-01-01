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
<<<<<<< HEAD
  version = "2.25.2";
=======
  version = "2.25.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-XtRcBEFWylUYmX4lArHyweczZAfLH7j+ES0US01Sgsg=";
=======
    hash = "sha256-YH08Q3IrfiF6fmyC8XJYt5i5KlEgF9YMBjI9Yq6BTNc=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
  meta = {
    description = "Library for the Spotify Web API";
    homepage = "https://spotipy.readthedocs.org/";
    changelog = "https://github.com/plamere/spotipy/blob/${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ rvolosatovs ];
=======
  meta = with lib; {
    description = "Library for the Spotify Web API";
    homepage = "https://spotipy.readthedocs.org/";
    changelog = "https://github.com/plamere/spotipy/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ rvolosatovs ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
