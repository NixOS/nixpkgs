{ stdenv, buildPythonPackage, fetchPypi, requests }:

buildPythonPackage rec {
  pname = "spotipy";
  version = "2.7.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1i4gpmvjk608fxz1kwfb3dnmm4dydr0bir0zw9k2nng7n8b6knvr";
  };

  propagatedBuildInputs = [ requests ];

  meta = with stdenv.lib; {
    homepage = https://spotipy.readthedocs.org/;
    description = "A light weight Python library for the Spotify Web API";
    license = licenses.mit;
    maintainers = [ maintainers.rvolosatovs ];
  };
}
