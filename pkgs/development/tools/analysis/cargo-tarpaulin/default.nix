{ lib, stdenv, rustPlatform, fetchFromGitHub, pkg-config, curl, openssl, Security }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-tarpaulin";
  version = "0.24.0";

  src = fetchFromGitHub {
    owner = "xd009642";
    repo = "tarpaulin";
    rev = version;
    sha256 = "sha256-5ZezJT1oxns6ZURj41UWLpfGs5dMUi8Vdv7OtwgVTF4=";
  };

  nativeBuildInputs = [
    pkg-config
  ];
  buildInputs = [ openssl ]
    ++ lib.optionals stdenv.isDarwin [ curl Security ];

  cargoHash = "sha256-vuwpaFUzN66jNj4lrDv2idMAm24o5ftYG40N56xeoqk=";
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
