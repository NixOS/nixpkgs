{ lib, stdenv, rustPlatform, fetchFromGitHub, pkg-config, curl, openssl, Security }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-tarpaulin";
  version = "0.20.1";

  src = fetchFromGitHub {
    owner = "xd009642";
    repo = "tarpaulin";
    rev = version;
    sha256 = "sha256-WobKZeO0U54mHj7hlkOH33TcOklWBJRWYSJBEt5sYII=";
  };

  nativeBuildInputs = [
    pkg-config
  ];
  buildInputs = [ openssl ]
    ++ lib.optionals stdenv.isDarwin [ curl Security ];

  cargoSha256 = "sha256-LR4jU7V44f00ry0VEd3qFryZtnn/t0K/OZGnRproksE=";
  #checkFlags = [ "--test-threads" "1" ];
  doCheck = false;

  meta = with lib; {
    description = "A code coverage tool for Rust projects";
    homepage = "https://github.com/xd009642/tarpaulin";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ hugoreeves ];
    platforms = lib.platforms.x86_64;
  };
}
