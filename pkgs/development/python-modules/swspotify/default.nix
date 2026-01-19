{
  lib,
  buildPythonPackage,
  dbus-python,
  fetchFromGitHub,
  flask,
  flask-cors,
  poetry-core,
  requests,
}:

buildPythonPackage rec {
  pname = "swspotify";
  version = "1.2.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "SwagLyrics";
    repo = "SwSpotify";
    rev = "v${version}";
    hash = "sha256-xGLvc154xnje45Akf7H1qqQRUc03gGVt8AhGlkcP3kY=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    dbus-python
    flask
    flask-cors
    requests
  ];

  pythonRelaxDeps = [
    "flask-cors"
    "flask"
  ];

  # Tests want to use Dbus
  doCheck = false;

  pythonImportsCheck = [ "SwSpotify" ];

  meta = {
    description = "Library to get the currently playing song and artist from Spotify";
    homepage = "https://github.com/SwagLyrics/SwSpotify";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ siraben ];
  };
}
