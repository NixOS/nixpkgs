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
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "rust-motd";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-iuADR7m+wdmsQ897o4CQHqDv9PmYu/vJgO5C6Dluao4=";
  };

  cargoSha256 = "sha256-kdSMcADoTpMU4w2XSv0pPQZC155rrQACQ4XTVyj7eeA=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ] ++ lib.optional stdenv.isDarwin Security;

  OPENSSL_NO_VENDOR = 1;

  meta = with lib; {
    description = "Beautiful, useful MOTD generation with zero runtime dependencies";
    homepage = "https://github.com/rust-motd/rust-motd";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
