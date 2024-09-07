{ lib
, rustPlatform
, fetchCrate
}:

rustPlatform.buildRustPackage rec {
  pname = "pulldown-cmark";
  version = "0.12.1";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-PfkmzmK98Mzay6P48NTEJhtpuoCiTb3JqUIYObcS41k=";
  };

  cargoHash = "sha256-BhlKFisM1ho7xcwBnjtODQdacE/B9UoqYXj3dIAeTXE=";

  meta = {
    description = "Pull parser for CommonMark written in Rust";
    homepage = "https://github.com/raphlinus/pulldown-cmark";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ CobaltCause ];
    mainProgram = "pulldown-cmark";
  };
}
