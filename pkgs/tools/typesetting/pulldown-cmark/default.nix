{ lib
, rustPlatform
, fetchCrate
}:

rustPlatform.buildRustPackage rec {
  pname = "pulldown-cmark";
  version = "0.9.4";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-B+Zxs88/F5B5TpgKLmcNX8rByGVVJcbTuwLcF8Ql9eE=";
  };

  cargoHash = "sha256-cIpixyAqeZ/EeEv4ChYiRpbRVD9xqJqxZz7kemxKC30=";

  meta = {
    description = "A pull parser for CommonMark written in Rust";
    homepage = "https://github.com/raphlinus/pulldown-cmark";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ CobaltCause ];
    mainProgram = "pulldown-cmark";
  };
}
