{ stdenv, buildPythonPackage, fetchPypi, requests, six, mock }:

buildPythonPackage rec {
  pname = "spotipy";
  version = "2.16.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1f50xczv8kgly6wz6zrvqzwdj6nvhdlgx8wnrhmbipjrb6qacr25";
  };

  propagatedBuildInputs = [ requests six ];
  checkInputs = [ mock ];

  preConfigure = ''
    substituteInPlace setup.py \
      --replace "mock==2.0.0" "mock"
  '';

  pythonImportsCheck = [ "spotipy" ];

  meta = with stdenv.lib; {
    homepage = "https://spotipy.readthedocs.org/";
    description = "A light weight Python library for the Spotify Web API";
    license = licenses.mit;
    maintainers = [ maintainers.rvolosatovs ];
  };
}
