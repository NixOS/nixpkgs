{ lib
, rustPlatform
, fetchFromGitHub
, nix-update-script
, stdenv
, libiconv
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-limit";
  version = "0.0.9";

  src = fetchFromGitHub {
    owner = "alopatindev";
    repo = "cargo-limit";
    rev = version;
    sha256 = "sha256-GRitz9LOdZhbakbLZI2BUfZjqXLrsMK2MQJgixiEHaA=";
  };

  cargoSha256 = "sha256-uiANH9HOvy41FiABTTx2D9Rz1z/F7eITc5aiofaMSfI=";

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
