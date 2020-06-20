{ stdenv, buildPythonPackage, fetchPypi, requests }:

buildPythonPackage rec {
  pname = "spotipy";
  version = "2.12.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f3a08edd516ffaf0731d40fdb7943445fe7b1b412700d042cbd168a726685222";
  };

  propagatedBuildInputs = [ requests ];

  meta = with stdenv.lib; {
    homepage = "https://spotipy.readthedocs.org/";
    description = "A light weight Python library for the Spotify Web API";
    license = licenses.mit;
    maintainers = [ maintainers.rvolosatovs ];
  };
}
