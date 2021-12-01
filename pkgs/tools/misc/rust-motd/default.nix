{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, openssl
, stdenv
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "rust-motd";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "rust-motd";
    repo = pname;
    rev = "v${version}";
    sha256 = "0xhdbhl0riaq9n4g9n333pgw966bsi60zpcy7gpndzfj21bj2x1m";
  };

  cargoSha256 = "sha256-l9Sit+niCLOnL1mdK6i8jea8NWsJlFM6p9lMTXyWOKY=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ] ++ lib.optional stdenv.isDarwin Security;

  meta = with lib; {
    description = "Beautiful, useful MOTD generation with zero runtime dependencies";
    homepage = "https://github.com/rust-motd/rust-motd";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
