{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage rec {
  pname = "pulldown-cmark";
  version = "0.11.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-1RE622jAtIxv9Jk6vMdm1djaaUCyNGXHIIela+WRubI=";
  };

  cargoHash = "sha256-L1KPpLw1MEYDisVdPEO16ZvSRx/ya22oDReyS+hG5t4=";

  meta = {
    description = "A pull parser for CommonMark written in Rust";
    homepage = "https://github.com/raphlinus/pulldown-cmark";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ CobaltCause ];
    mainProgram = "pulldown-cmark";
  };
}
