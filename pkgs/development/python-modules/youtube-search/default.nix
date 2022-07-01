{ lib, buildPythonPackage, fetchPypi, requests }:

buildPythonPackage rec {
  pname = "youtube-search";
  version = "2.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1541120273996fa433698b2e57b73296dfb8e90536211f29ea997dcf161b66fe";
  };

  propagatedBuildInputs = [ requests ];

  # tests require network connection
  doCheck = false;

  pythonImportsCheck = [ "youtube_search" ];

  meta = with lib; {
    description = "Tool for searching for youtube videos to avoid using their heavily rate-limited API";
    homepage = "https://github.com/joetats/youtube_search";
    license = licenses.mit;
    maintainers = with maintainers; [ j0hax ];
  };
}
