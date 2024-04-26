{ lib
, rustPlatform
, fetchCrate
}:

rustPlatform.buildRustPackage rec {
  pname = "pulldown-cmark";
  version = "0.10.3";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-lJTMMXjuam872p+3+uesODd3s3/IJFg476AssikhI48=";
  };

  cargoHash = "sha256-P0Wem+iEnjq+iyJYw0QqwFQ7UuG/BMKEUernykjg44o=";

  meta = {
    description = "A pull parser for CommonMark written in Rust";
    homepage = "https://github.com/raphlinus/pulldown-cmark";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ CobaltCause ];
    mainProgram = "pulldown-cmark";
  };
}
