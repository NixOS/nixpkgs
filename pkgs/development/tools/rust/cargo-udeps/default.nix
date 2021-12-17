{ lib, stdenv, rustPlatform, fetchFromGitHub, pkg-config, openssl, CoreServices, Security, libiconv, SystemConfiguration }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-udeps";
  version = "0.1.24";

  src = fetchFromGitHub {
    owner = "est31";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-/A3OaJje8AT4zR91sLAYN6lsKiv2FbSBYAeuc79nSF0=";
  };

  cargoSha256 = "sha256-1LXcuLmbW0ezLJG0sszQDZqa2cRaMMC4blNjmFg1Ltc=";

  nativeBuildInputs = [ pkg-config ];

  # TODO figure out how to use provided curl instead of compiling curl from curl-sys
  buildInputs = [ openssl ]
    ++ lib.optionals stdenv.isDarwin [ CoreServices Security libiconv SystemConfiguration ];

  # Requires network access
  doCheck = false;

  meta = with lib; {
    description = "Find unused dependencies in Cargo.toml";
    homepage = "https://github.com/est31/cargo-udeps";
    license = licenses.mit;
    maintainers = with maintainers; [ b4dm4n ];
  };
}
