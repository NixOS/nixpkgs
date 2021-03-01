{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "galene";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "jech";
    repo = "galene";
    rev = "galene-${version}";
    sha256 = "sha256-bARFSfsra4OhHqj/0KDtLLh2LByxt9NysLFAEuVxDIs=";
  };

  vendorSha256 = "sha256-96TRsEW/AEPKK+ez5gxMoG2w3KbL2H/tKkJOyIo3LEs=";

  outputs = [ "out" "static" ];

  postInstall = ''
    mkdir $static
    cp -r ./static $static
  '';

  meta = with lib; {
    description = "Videoconferencing server that is easy to deploy, written in Go";
    homepage = "https://github.com/jech/galene";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ rgrunbla ];
  };
}
