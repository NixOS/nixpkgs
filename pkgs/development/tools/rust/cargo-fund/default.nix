{ stdenv, fetchFromGitHub, pkg-config, rustPlatform, Security, curl, openssl, libiconv }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-fund";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "acfoltzer";
    repo = pname;
    rev = version;
    sha256 = "1jim5bgq3fc33391qpa1q1csbzqf4hk1qyfzwxpcs5pb4ixb6vgk";
  };

  cargoSha256 = "181gcmaw2w5a6ah8a2ahsnc1zkadpmx1azkwh2a6x8myhzw2dxsj";

  # The tests need a GitHub API token.
  doCheck = false;

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ] ++ stdenv.lib.optionals stdenv.isDarwin [ Security libiconv curl ];

  meta = with stdenv.lib; {
    description = "Discover funding links for your project's dependencies";
    homepage = "https://github.com/acfoltzer/cargo-fund";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ johntitor ];
  };
}
