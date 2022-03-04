{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "mpd-discord-rpc";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "JakeStanger";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-CdgR9G598LmxA9lhY6yppP3ZZUhTqgMcWccEhSuCcJQ=";
  };

  cargoSha256 = "sha256-WhlVWQCUGP+K9md0yp6ZD6mGYMso1fUYKDuXXrC2FeI=";

  meta = with lib; {
    description = "Rust application which displays your currently playing song / album / artist from MPD in Discord using Rich Presence";
    homepage = "https://github.com/JakeStanger/mpd-discord-rpc";
    license = licenses.mit;
    maintainers = with maintainers; [ kranzes ];
  };
}
