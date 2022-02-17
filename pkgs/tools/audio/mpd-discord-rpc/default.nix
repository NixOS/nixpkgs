{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "mpd-discord-rpc";
  version = "1.2.3";

  src = fetchFromGitHub {
    owner = "JakeStanger";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-FkdndkXj48JLKRwZ9lLVQrGU7QvBZvYC9Y2iYS0RiCY=";
  };

  cargoSha256 = "sha256-w6Usc86yn7mq/wxljSpko/JPnLHmkyeILKa31YsQrFg=";

  meta = with lib; {
    description = "Rust application which displays your currently playing song / album / artist from MPD in Discord using Rich Presence";
    homepage = "https://github.com/JakeStanger/mpd-discord-rpc";
    license = licenses.mit;
    maintainers = with maintainers; [ kranzes ];
  };
}
