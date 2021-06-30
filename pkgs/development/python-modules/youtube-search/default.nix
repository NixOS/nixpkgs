{ lib, buildPythonPackage, fetchFromGitHub, requests }:

buildPythonPackage rec {
  pname = "youtube-search";
  version = "unstable-2021-02-27";

  src = fetchFromGitHub {
    owner = "joetats";
    repo = "youtube_search";
    rev = "886fe1b16c829215ee0984b6859f874b4a30d875";
    sha256 = "sha256-3ECJ6iHNzx5PLgpTFraFzAYbKnyMYRf/iJ0zajU+hlo=";
  };

  propagatedBuildInputs = [ requests ];

  # Check disabled due to relative import with no known parent package
  doCheck = false;
  pythonImportsCheck = [ "youtube_search" ];

  meta = with lib; {
    description = "Tool for searching for youtube videos to avoid using their heavily rate-limited API";
    homepage = "https://github.com/joetats/youtube_search";
    license = licenses.mit;
    maintainers = with maintainers; [ j0hax ];
  };
}
