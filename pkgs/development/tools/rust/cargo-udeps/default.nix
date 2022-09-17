{ lib, stdenv, rustPlatform, fetchFromGitHub, pkg-config, openssl, CoreServices, Security, libiconv, SystemConfiguration }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-udeps";
  version = "0.1.32";

  src = fetchFromGitHub {
    owner = "est31";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Ev7hLtE5/PqeM39nyWaMyIhFsEZnXbdyU8Q5PET98lQ=";
  };

  cargoSha256 = "sha256-3+6hZCYiyG6fgyJpjCcY1dzDK0kwVjsyckPIq/8Zfm0=";

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
