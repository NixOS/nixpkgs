{ stdenv, buildPythonPackage, fetchPypi, requests }:

buildPythonPackage rec {
  pname = "spotipy";
  version = "2.9.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "163z3j0sd9a7cc9pv9hcrh230gisvvi2fxabh1f6nzhfr8avrncr";
  };

  propagatedBuildInputs = [ requests ];

  meta = with stdenv.lib; {
    homepage = "https://spotipy.readthedocs.org/";
    description = "A light weight Python library for the Spotify Web API";
    license = licenses.mit;
    maintainers = [ maintainers.rvolosatovs ];
  };
}
