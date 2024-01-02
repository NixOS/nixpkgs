{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "turtle-build";
  version = "0.4.7";

  src = fetchFromGitHub {
    owner = "raviqqe";
    repo = "turtle-build";
    rev = "v${version}";
    hash = "sha256-pyCswNJ4LuXViewQl+2o5g06uVjXVphxh2wXO9m5Mec=";
  };

  cargoHash = "sha256-ObPzzYh8Siu01DH/3pXk322H7NaD7sHYTYBUk0WvZUs=";

  meta = with lib; {
    description = "Ninja-compatible build system for high-level programming languages written in Rust";
    homepage = "https://github.com/raviqqe/turtle-build";
    license = with licenses; [ asl20 mit ];
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "turtle";
  };
}
