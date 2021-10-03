{ lib, buildPythonPackage, pythonOlder, fetchPypi, httpx }:

buildPythonPackage rec {
  pname = "youtube-search-python";
  version = "1.4.9";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9c75540d41f6dcfd19f2f70fbe8346406e026a016aae56b87c207a0b4ff571e0";
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
