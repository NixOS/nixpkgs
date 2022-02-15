{ lib, fetchFromGitHub, buildGoModule }:
buildGoModule rec {
  pname = "mmctl";
  version = "6.3.0";

  src = fetchFromGitHub {
    owner = "mattermost";
    repo = "mmctl";
    rev = "v${version}";
    sha256 = "sha256-hrNVDHM8AweAdda9SC29EGhkOhdiLD0EE1BLPhwe5SI=";
  };

  vendorSha256 = null;

  checkPhase = "make test";

  meta = with lib; {
    description = "A remote CLI tool for Mattermost";
    homepage = "https://github.com/mattermost/mmctl";
    license = licenses.asl20;
    maintainers = with maintainers; [ ppom ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
