{ lib, buildPythonPackage, pythonOlder, fetchPypi, httpx }:

buildPythonPackage rec {
  pname = "youtube-search-python";
  version = "1.5.1";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "68c70e1b6a2ce5c2c0ee64ba9c63efc9ab6e6f8acb2f51e19d570b0287e61cc9";
  };

  propagatedBuildInputs = [ httpx ];

  pythonImportsCheck = [ "youtubesearchpython" ];

  # project has no tests
  doCheck = false;

  meta = with lib; {
    description =
      "Search for YouTube videos, channels & playlists & get video information using link WITHOUT YouTube Data API v3";
    homepage = "https://github.com/alexmercerind/youtube-search-python";
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
  };
}
