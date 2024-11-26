{ lib, stdenv, fetchFromGitHub, pkg-config, rustPlatform, Security, curl, openssl, libiconv }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-fund";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "acfoltzer";
    repo = pname;
    rev = version;
    hash = "sha256-8mnCwWwReNH9s/gbxIhe7XdJRIA6BSUKm5jzykU5qMU=";
  };

  cargoHash = "sha256-J4AylYE4RTRPTUz5Hek7D34q9HjlFnrc/z/ax0i6lPQ=";

  # The tests need a GitHub API token.
  doCheck = false;

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ Security libiconv curl ];

  meta = with lib; {
    description = "Discover funding links for your project's dependencies";
    mainProgram = "cargo-fund";
    homepage = "https://github.com/acfoltzer/cargo-fund";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ johntitor ];
  };
}
