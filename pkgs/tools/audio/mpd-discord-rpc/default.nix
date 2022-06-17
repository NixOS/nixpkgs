{ stdenv
, lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, openssl
}:

rustPlatform.buildRustPackage rec {
  pname = "mpd-discord-rpc";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "JakeStanger";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-jwsfUepGJ7IB1H6Er1EszYkkYIOSyuFvTX7NF9UhhGo=";
  };

  cargoSha256 = "sha256-4MUfjXWDZmfsUzvWo8I2fgzm4jOfX1ZgHYqUmxXJ/BU=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "Rust application which displays your currently playing song / album / artist from MPD in Discord using Rich Presence";
    homepage = "https://github.com/JakeStanger/mpd-discord-rpc";
    license = licenses.mit;
    maintainers = with maintainers; [ kranzes ];
  };
}
