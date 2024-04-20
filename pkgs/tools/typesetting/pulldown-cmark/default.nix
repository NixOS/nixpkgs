{ lib
, rustPlatform
, fetchCrate
}:

rustPlatform.buildRustPackage rec {
  pname = "pulldown-cmark";
  version = "0.10.2";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-jRQ2BnaElhciyBPQiHw680uFC6FXs+rP8rJGWH5ZbCc=";
  };

  cargoHash = "sha256-UsdssFfy7cTM0wrfLDLrzbKudB5vqFINInJAteH5OTk=";

  meta = {
    description = "A pull parser for CommonMark written in Rust";
    homepage = "https://github.com/raphlinus/pulldown-cmark";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ CobaltCause ];
    mainProgram = "pulldown-cmark";
  };
}
