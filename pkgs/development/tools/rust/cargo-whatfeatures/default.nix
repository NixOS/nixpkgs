{ lib, stdenv, fetchFromGitHub, rustPlatform, pkg-config, openssl, Security }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-whatfeatures";
  version = "0.9.13";

  src = fetchFromGitHub {
    owner = "museun";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-YJ08oBTn9OwovnTOuuc1OuVsQp+/TPO3vcY4ybJ26Ms=";
  };

  cargoHash = "sha256-Zi9FCNBxQ9S4S9k6hoMUOixTs6PJyxmgTB+ArrX8oBE=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [ Security ];

  meta = with lib; {
    description = "Simple cargo plugin to get a list of features for a specific crate";
    mainProgram = "cargo-whatfeatures";
    homepage = "https://github.com/museun/cargo-whatfeatures";
    license = with licenses; [ mit asl20 ];
    maintainers = with maintainers; [ ivan-babrou matthiasbeyer ];
  };
}
