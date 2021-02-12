{ lib
, rustPlatform
, fetchFromGitHub
, nix-update-script
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-limit";
  version = "0.0.5";

  src = fetchFromGitHub {
    owner = "alopatindev";
    repo = "cargo-limit";
    rev = version;
    sha256 = "sha256-GYdWKRgdS9gCQRu1C8ht0wC1eBTtIMg585OuAfDn/+4=";
  };

  cargoSha256 = "0cq7r34nlvsqkqnr344qwzky6sdlfpllvcjc56iq2azvi8ya9lx0";

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
