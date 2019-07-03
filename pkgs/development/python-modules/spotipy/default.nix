{ stdenv, buildPythonPackage, fetchPypi, requests }:

buildPythonPackage rec {
  pname = "spotipy";
  version = "2.4.4";
  name = pname + "-" + version;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1l8ya0cln936x0mx2j5ngl1xwpc0r89hs3wcvb8x8paw3d4dl1ab";
  };

  propagatedBuildInputs = [ requests ];

  meta = with stdenv.lib; {
    homepage = https://spotipy.readthedocs.org/;
    description = "A light weight Python library for the Spotify Web API";
    license = licenses.mit;
    maintainers = [ maintainers.rvolosatovs ];
  };
}
