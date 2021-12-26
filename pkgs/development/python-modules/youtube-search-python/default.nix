{ lib, buildPythonPackage, pythonOlder, fetchPypi, httpx }:

buildPythonPackage rec {
  pname = "youtube-search-python";
  version = "1.5.2";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "33f0d58f4803b0b2badf860cd31fb83d3f7edecdd2c01dd09cd6511abbf0e6b9";
  };

  propagatedBuildInputs = [ httpx ];

  pythonImportsCheck = [ "youtubesearchpython" ];

  # project has no tests
  doCheck = false;

  meta = with lib; {
    description = "Search for YouTube videos, channels & playlists & get video information using link WITHOUT YouTube Data API v3";
    homepage = "https://github.com/alexmercerind/youtube-search-python";
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
  };
}
