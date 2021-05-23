{ lib, stdenv, fetchFromGitHub, pkg-config, rustPlatform, Security, curl, openssl, libiconv }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-fund";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "acfoltzer";
    repo = pname;
    rev = version;
    sha256 = "1jim5bgq3fc33391qpa1q1csbzqf4hk1qyfzwxpcs5pb4ixb6vgk";
  };

  cargoSha256 = "1c2zryxn1bbg3ksp8azk9xmwfgwr6663hlmdv9c358hzqdfp9hli";

  # The tests need a GitHub API token.
  doCheck = false;

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ] ++ lib.optionals stdenv.isDarwin [ Security libiconv curl ];

  meta = with lib; {
    description = "Discover funding links for your project's dependencies";
    homepage = "https://github.com/acfoltzer/cargo-fund";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ johntitor ];
  };
}
