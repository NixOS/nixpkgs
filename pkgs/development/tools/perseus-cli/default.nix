{ lib
, stdenv
, rustPlatform
, fetchCrate
, makeWrapper
, wasm-pack
, CoreServices
}:

rustPlatform.buildRustPackage rec {
  pname = "perseus-cli";
  version = "0.3.1";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-IYjLx9/4oWSXa4jhOtGw1GOHmrR7LQ6bWyN5zbOuEFs=";
  };

  cargoHash = "sha256-i7MPmO9MoANZLzmR5gsD+v0gyDtFbzhsmE9xOsb88L0=";

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = lib.optionals stdenv.isDarwin [ CoreServices ];

  postInstall = ''
    wrapProgram $out/bin/perseus \
      --prefix PATH : "${lib.makeBinPath [ wasm-pack ]}"
  '';

  meta = with lib; {
    homepage = "https://arctic-hen7.github.io/perseus";
    description = "High-level web development framework for Rust with full support for server-side rendering and static generation";
    maintainers = with maintainers; [ max-niederman ];
    license = with licenses; [ mit ];
    mainProgram = "perseus";
  };
}
