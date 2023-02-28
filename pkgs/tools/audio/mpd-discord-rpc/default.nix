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
  version = "1.5.4b";

  src = fetchFromGitHub {
    owner = "JakeStanger";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-SMAllqxfae8bNLBkxsY4OmjoIzxFZ0dwIRYconlNZ18=";
  };

  cargoSha256 = "sha256-vqKKv8eNXkDqcgjlybisSmNBijpvHEKsFAENYjD8zQI=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ] ++ lib.optional stdenv.isDarwin Security;

  meta = with lib; {
    description = "Rust application which displays your currently playing song / album / artist from MPD in Discord using Rich Presence";
    homepage = "https://github.com/JakeStanger/mpd-discord-rpc";
    license = licenses.mit;
    maintainers = with maintainers; [ kranzes ];
  };
}
