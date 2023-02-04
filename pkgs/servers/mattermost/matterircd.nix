{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "matterircd";
  version = "0.26.1";

  src = fetchFromGitHub {
    owner = "42wim";
    repo = "matterircd";
    rev = "v${version}";
    sha256 = "sha256-yC5b3OEylIOS4lWz+ZiHHy3ShLjkaNzDt4dX1E87iR0=";
  };

  vendorSha256 = null;

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "Minimal IRC server bridge to Mattermost";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    platforms = platforms.unix;
  };
}
