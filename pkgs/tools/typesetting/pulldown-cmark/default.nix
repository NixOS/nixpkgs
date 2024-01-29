{ lib
, rustPlatform
, fetchCrate
}:

rustPlatform.buildRustPackage rec {
  pname = "pulldown-cmark";
  version = "0.9.5";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-8hqA808w7eUZgFVoEct8IAZcRUb2xGxj5lYsIvP2TUU=";
  };

  cargoHash = "sha256-GRESQh8dWdzd80ZCjiVfqNXcHloHvQ/eb9xztT7qMNo=";

  meta = {
    description = "A pull parser for CommonMark written in Rust";
    homepage = "https://github.com/raphlinus/pulldown-cmark";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ CobaltCause ];
    mainProgram = "pulldown-cmark";
  };
}
