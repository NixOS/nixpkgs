{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "pulldown-cmark";
  version = "0.9.3";

  src = fetchFromGitHub {
    owner = "raphlinus";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-FK/+6N81qYyFsisPn5SkpubvWMYO7dLX9iHgNY/tAo4=";
  };

  cargoHash = "sha256-fcVnIb6WPRk133uTMH0xxmEJ3YgsftsTJXjqfOQQPDI=";

  meta = {
    description = "A pull parser for CommonMark written in Rust";
    homepage = "https://github.com/raphlinus/pulldown-cmark";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ CobaltCause ];
    mainProgram = "pulldown-cmark";
  };
}
