{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "mpd-discord-rpc";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "JakeStanger";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Vo/7vWTpriet0hsxfx9Uj8UWfJZbuwgVSSpxA1vVjXI=";
  };

  cargoSha256 = "sha256-sj6qsYnFc86Fz2xPhkdh7I59muAPeYFA9qVGw9FtLFE=";

  meta = with lib; {
    description = "Rust application which displays your currently playing song / album / artist from MPD in Discord using Rich Presence";
    homepage = "https://github.com/JakeStanger/mpd-discord-rpc";
    license = licenses.mit;
    maintainers = with maintainers; [ kranzes ];
  };
}
