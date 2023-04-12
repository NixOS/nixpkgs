{ lib
, rustPlatform
, fetchFromGitHub
, nix-update-script
, stdenv
, libiconv
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-limit";
  version = "0.0.10";

  src = fetchFromGitHub {
    owner = "alopatindev";
    repo = "cargo-limit";
    rev = version;
    sha256 = "sha256-joWDB9fhCsYVZFZdr+Gfm4JaRlm5kj+CHp34Sx5iQYk=";
  };

  cargoSha256 = "sha256-dwqbG0UFeUQHa0K98ebHfjbcQuQOhK2s6ZxAT6r0cik=";

  buildInputs = lib.optionals stdenv.isDarwin [ libiconv ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Cargo subcommand \"limit\": reduces the noise of compiler messages";
    homepage = "https://github.com/alopatindev/cargo-limit";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ otavio ];
  };
}
