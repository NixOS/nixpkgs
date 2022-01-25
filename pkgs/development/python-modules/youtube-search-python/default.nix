{ lib, buildPythonPackage, pythonOlder, fetchPypi, httpx }:

buildPythonPackage rec {
  pname = "youtube-search-python";
  version = "1.6.1";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c7afe70e1ac8e871341d7fb15f5246aac35fd80fec10d7a96d46df2aad608bd0";
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
