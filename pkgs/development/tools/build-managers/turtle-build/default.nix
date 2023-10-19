{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "turtle-build";
  version = "0.4.6";

  src = fetchFromGitHub {
    owner = "raviqqe";
    repo = "turtle-build";
    rev = "v${version}";
    hash = "sha256-7XorSt2LFWYNdvCot+I7Uh6S1mhRbD7PkWkvYdIbjKs=";
  };

  cargoHash = "sha256-TebXKOgBdf/ZFITQu5OuusytDJKEkGzRD7fLhk1uh8Y=";

  meta = with lib; {
    description = "Ninja-compatible build system for high-level programming languages written in Rust";
    homepage = "https://github.com/raviqqe/turtle-build";
    license = with licenses; [ asl20 mit ];
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "turtle";
  };
}
