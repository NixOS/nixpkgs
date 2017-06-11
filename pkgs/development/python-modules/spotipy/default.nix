{ stdenv, buildPythonPackage, fetchPypi, requests2 }:

buildPythonPackage rec {
  pname = "spotipy";
  name = "spotipy-${version}";
  version = "2.4.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1l8ya0cln936x0mx2j5ngl1xwpc0r89hs3wcvb8x8paw3d4dl1ab";
  };

  propagatedBuildInputs = [ requests2 ];

  meta = with stdenv.lib; {
    homepage = "http://spotipy.readthedocs.org/";
    description = "A light weight Python library for the Spotify Web API";
    license = licenses.mit;
    maintainers = [ maintainers.rvolosatovs ];
  };
}
