{
  lib,
  buildPythonPackage,
  fetchPypi,
  requests,
}:

buildPythonPackage rec {
  pname = "youtube-search";
  version = "2.1.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-V0mm2Adv2mVVfJE2fw+rCTYpDs3qRXyDHJ8/BZGKOqI=";
  };

  propagatedBuildInputs = [ requests ];

  # Tests require network connection
  doCheck = false;

  pythonImportsCheck = [ "youtube_search" ];

  meta = {
    description = "Tool for searching for youtube videos to avoid using their heavily rate-limited API";
    homepage = "https://github.com/joetats/youtube_search";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ j0hax ];
  };
}
