{ lib
, rustPlatform
, fetchFromGitHub
, nix-update-script
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-limit";
  version = "0.0.7";

  src = fetchFromGitHub {
    owner = "alopatindev";
    repo = "cargo-limit";
    rev = version;
    sha256 = "sha256-8HsYhWYeRhCPTxVnU8hOJKLXvza8i9KvKTLL6yLo0+c=";
  };

  cargoSha256 = "sha256-8uA4oFExrzDMeMV5MacbtE0Awdfx+jUUkrKd7ushOHo=";

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
