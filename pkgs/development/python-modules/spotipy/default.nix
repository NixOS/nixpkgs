{ stdenv, buildPythonPackage, fetchPypi, requests }:

buildPythonPackage rec {
  pname = "spotipy";
  version = "2.10.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0s2f9yxhfkfipbb06965gfjq4lg0khp5vcykijrx6dzxyh20vggm";
  };

  propagatedBuildInputs = [ requests ];

  meta = with stdenv.lib; {
    homepage = "https://spotipy.readthedocs.org/";
    description = "A light weight Python library for the Spotify Web API";
    license = licenses.mit;
    maintainers = [ maintainers.rvolosatovs ];
  };
}
