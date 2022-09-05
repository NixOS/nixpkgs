{ stdenv
, lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, openssl
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "mpd-discord-rpc";
  version = "1.5.2";

  src = fetchFromGitHub {
    owner = "JakeStanger";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-/QWIoP6KcrI8cYTh3x2lQz7nPSvzb1zRWg8TFoYY9vE=";
  };

  cargoSha256 = "sha256-46PS1+ud7GYuMOJMp93Hf7+nlngvgL67zedaF44TcYY=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ] ++ lib.optional stdenv.isDarwin Security;

  meta = with lib; {
    description = "Rust application which displays your currently playing song / album / artist from MPD in Discord using Rich Presence";
    homepage = "https://github.com/JakeStanger/mpd-discord-rpc";
    license = licenses.mit;
    maintainers = with maintainers; [ kranzes ];
  };
}
