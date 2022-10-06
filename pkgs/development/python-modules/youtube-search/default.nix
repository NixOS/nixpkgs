{ lib, buildPythonPackage, fetchPypi, requests }:

buildPythonPackage rec {
  pname = "youtube-search";
  version = "2.1.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-V0mm2Adv2mVVfJE2fw+rCTYpDs3qRXyDHJ8/BZGKOqI=";
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
