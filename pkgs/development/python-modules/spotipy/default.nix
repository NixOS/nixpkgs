{ stdenv, buildPythonPackage, fetchPypi, requests, six, mock }:

buildPythonPackage rec {
  pname = "spotipy";
  version = "2.16.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "315eadd1248053ed336b4d3adbf2e3c32895fdbb0cfcd170542c848c8fd45649";
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
