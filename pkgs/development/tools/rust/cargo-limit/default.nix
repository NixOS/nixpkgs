{ lib
, rustPlatform
, fetchFromGitHub
, nix-update-script
, stdenv
, libiconv
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-limit";
  version = "0.0.8";

  src = fetchFromGitHub {
    owner = "alopatindev";
    repo = "cargo-limit";
    rev = version;
    sha256 = "sha256-OHBxQcXhZkJ1F6xLc7/sPpJhJzuJXb91IUjAtyC3XP8=";
  };

  cargoSha256 = "sha256-LxqxRtMKUKZeuvk1caoYy8rv1bkEOQBM8i5SXMF4GXc=";

  buildInputs = lib.optionals stdenv.isDarwin [ libiconv ];

  passthru = {
    updateScript = nix-update-script {
      attrPath = pname;
    };
  };

  meta = with lib; {
    description = "Cargo subcommand \"limit\": reduces the noise of compiler messages";
    homepage = "https://github.com/alopatindev/cargo-limit";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ otavio ];
  };
}
