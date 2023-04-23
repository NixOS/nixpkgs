{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "matterircd";
  version = "0.27.0";

  src = fetchFromGitHub {
    owner = "42wim";
    repo = "matterircd";
    rev = "v${version}";
    sha256 = "sha256-gJHFAvgEZ26Jj3MfaUB7u/8jWtVHa9mjWfo+hFfo9u0=";
  };

  vendorHash = null;

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "Minimal IRC server bridge to Mattermost";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    platforms = platforms.unix;
  };
}
