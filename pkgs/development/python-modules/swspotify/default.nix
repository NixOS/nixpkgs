{ lib, stdenv, buildPythonPackage, fetchFromGitHub, requests
, pytestCheckHook, flask, flask-cors, dbus-python, mock, isPy27
, poetry-core }:

buildPythonPackage rec {
  pname = "SwSpotify";
  version = "1.2.3";
  disabled = isPy27;
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "SwagLyrics";
    repo = "SwSpotify";
    rev = "v${version}";
    sha256 = "sha256-xGLvc154xnje45Akf7H1qqQRUc03gGVt8AhGlkcP3kY=";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [ requests flask flask-cors ]
    ++ lib.optionals stdenv.isLinux [ dbus-python ];

  doCheck = !stdenv.isDarwin;

  checkPhase = ''
    pytest tests/test_spotify.py::${if stdenv.isDarwin then "DarwinTests" else "LinuxTests"}
  '';

  checkInputs = [ pytestCheckHook mock ];

  pythonImportsCheck = [ "SwSpotify" ];

  meta = with lib; {
    homepage = "https://github.com/SwagLyrics/SwSpotify";
    description = "Library to get the currently playing song and artist from Spotify";
    license = licenses.mit;
    maintainers = with maintainers; [ siraben ];
    platforms = platforms.unix;
  };
}
