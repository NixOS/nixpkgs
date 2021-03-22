{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "matterircd";
  version = "0.24.0";

  src = fetchFromGitHub {
    owner = "42wim";
    repo = "matterircd";
    rev = "v${version}";
    sha256 = "sha256-8tTkSEv7WGygx/d3z3RX6oDZk/JekJT/rViKco6rIRs=";
  };

  goPackagePath = "github.com/42wim/matterircd";

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "Minimal IRC server bridge to Mattermost";
    license = licenses.mit;
    maintainers = with maintainers; [ fpletz ];
    platforms = platforms.unix;
  };
}
