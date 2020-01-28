{ stdenv, buildPythonPackage, fetchPypi, requests }:

buildPythonPackage rec {
  pname = "spotipy";
  version = "2.6.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1jpj9ljc5g89jbnzwnmgz5s6jdrsgd6g9s09igvbw3pppi9070h0";
  };

  propagatedBuildInputs = [ requests ];

  meta = with stdenv.lib; {
    homepage = https://spotipy.readthedocs.org/;
    description = "A light weight Python library for the Spotify Web API";
    license = licenses.mit;
    maintainers = [ maintainers.rvolosatovs ];
  };
}
