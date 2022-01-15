{ lib, buildPythonPackage, pythonOlder, fetchPypi, httpx }:

buildPythonPackage rec {
  pname = "youtube-search-python";
  version = "1.5.3";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4bc39224d1f0915692101a7739289c41173de2eb88b445aabc7be284802b7489";
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
