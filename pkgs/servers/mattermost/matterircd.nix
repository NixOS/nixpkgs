{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "matterircd";
  version = "0.23.1";

  src = fetchFromGitHub {
    owner = "42wim";
    repo = "matterircd";
    rev = "v${version}";
    sha256 = "sha256-1oItl0mLyAFah9qaaYl+IAT/H4X+GW82GBHYuLWacVI=";
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
