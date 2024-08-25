{ lib
, rustPlatform
, fetchCrate
}:

rustPlatform.buildRustPackage rec {
  pname = "pulldown-cmark";
  version = "0.12.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-LBaWfcTA5qxhrEUG0FeusGZBgvRjuQS0/1pqeKQQWbk=";
  };

  cargoHash = "sha256-UPv7F/itmISaUikR6jdAj3FvTF56VqwdMvD3L3WruA4=";

  meta = {
    description = "Pull parser for CommonMark written in Rust";
    homepage = "https://github.com/raphlinus/pulldown-cmark";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ CobaltCause ];
    mainProgram = "pulldown-cmark";
  };
}
