{ lib
, rustPlatform
, fetchCrate
}:

rustPlatform.buildRustPackage rec {
  pname = "pulldown-cmark";
  version = "0.11.2";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-Ox/5xp46/RjfJkn74dPcQQSBMa5Mtx98wbVSnpbViks=";
  };

  cargoHash = "sha256-+bbd/SjHM/hbxaOP2CbzZ7wI5ZzVTIHw9she8wm+M3w=";

  meta = {
    description = "Pull parser for CommonMark written in Rust";
    homepage = "https://github.com/raphlinus/pulldown-cmark";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ CobaltCause ];
    mainProgram = "pulldown-cmark";
  };
}
