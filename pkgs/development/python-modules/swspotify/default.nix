{
  lib,
  buildPythonPackage,
  dbus-python,
  fetchFromGitHub,
  flask,
  flask-cors,
  poetry-core,
  pythonOlder,
  requests,
}:

buildPythonPackage rec {
  pname = "swspotify";
  version = "1.2.3";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "SwagLyrics";
    repo = "SwSpotify";
    rev = "v${version}";
    hash = "sha256-xGLvc154xnje45Akf7H1qqQRUc03gGVt8AhGlkcP3kY=";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [
    dbus-python
    flask
    flask-cors
    requests
  ];

  # Tests want to use Dbus
  doCheck = false;

  pythonImportsCheck = [ "SwSpotify" ];

  meta = with lib; {
    description = "Library to get the currently playing song and artist from Spotify";
    homepage = "https://github.com/SwagLyrics/SwSpotify";
    license = licenses.mit;
    maintainers = with maintainers; [ siraben ];
  };
}
