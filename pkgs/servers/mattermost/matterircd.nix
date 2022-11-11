{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "matterircd";
  version = "0.25.1";

  src = fetchFromGitHub {
    owner = "42wim";
    repo = "matterircd";
    rev = "v${version}";
    sha256 = "sha256-qglr0QN0ca6waxhwEFgYP9RHvTJ4YVn90vl+crcktao=";
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
