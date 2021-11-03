{ lib, stdenv, buildPythonPackage, fetchFromGitHub, poetry-core, requests
, pytestCheckHook, flask, flask-cors, dbus-python, mock, isPy27 }:

buildPythonPackage rec {
  pname = "SwSpotify";
  version = "1.2.2";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "SwagLyrics";
    repo = "SwSpotify";
    rev = "v${version}";
    sha256 = "sha256-571knnY8LegIbqyPeKUfl+d0suTWAMQHYLN7edKFNdI=";
  };

  propagatedBuildInputs = [
    requests flask flask-cors dbus-python
  ];

  preConfigure = ''
    substituteInPlace setup.py \
      --replace 'flask==2.0.1' 'flask'
  '';

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
