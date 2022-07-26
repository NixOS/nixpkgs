{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, openssl
}:

rustPlatform.buildRustPackage rec {
  pname = "lychee";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "lycheeverse";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-XjG4u0z3u89Wg2lrcD3T0OqNMgLxmKO1e1zYlGd3dqQ=";
  };

  cargoSha256 = "sha256-aXxhKH0dB6VpXfoWJwXBjsxGFcK071MZfCoi4z9uHdc=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  # Disabled because they currently fail
  doCheck = false;

  meta = with lib; {
    description = "A fast, async, resource-friendly link checker written in Rust.";
    homepage = "https://github.com/lycheeverse/lychee";
    license = with licenses; [ asl20 mit ];
    maintainers = with maintainers; [ tuxinaut ];
    platforms = platforms.linux;
  };
}
