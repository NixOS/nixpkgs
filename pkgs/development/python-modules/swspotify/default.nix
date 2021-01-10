{ lib, buildPythonPackage, fetchFromGitHub, requests, flask-cors, dbus-python, pytestCheckHook, mock, isPy27 }:

buildPythonPackage rec {
  pname = "SwSpotify";
  version = "1.2.1";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "SwagLyrics";
    repo = "SwSpotify";
    rev = "v${version}";
    sha256 = "0jxcvy8lw8kpjbl4q6mi11164pvi0w9m9p76bxj2m7i7s5p4dxd4";
  };

  propagatedBuildInputs = [
    requests flask-cors dbus-python
  ];

  preConfigure = ''
    substituteInPlace setup.py \
      --replace 'requests>=2.24.0' 'requests~=2.23' \
      --replace 'flask-cors==3.0.8' 'flask-cors'
  '';

  checkPhase = ''
    pytest tests/test_spotify.py::LinuxTests
  '';

  checkInputs = [ pytestCheckHook mock ];

  pythonImportsCheck = [ "SwSpotify" ];

  meta = with lib; {
    homepage = "https://github.com/SwagLyrics/SwSpotify";
    description = "Library to get the currently playing song and artist from Spotify";
    license = licenses.mit;
    maintainers = with maintainers; [ siraben ];
    platforms = platforms.linux;
  };
}
