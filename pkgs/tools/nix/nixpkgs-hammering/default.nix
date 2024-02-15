{ lib
, fetchFromGitHub
, rustPlatform
, stdenv
, makeWrapper
, python3
, nix
}:

let
  version = "unstable-2023-11-06";

  src = fetchFromGitHub {
    owner = "jtojnar";
    repo = "nixpkgs-hammering";
    rev = "8e33fc1e7b3b311ce3ba9c5c8c9e7cf89041b893";
    hash = "sha256-D9c6EZMHy0aldzMxj4Ivw1YXNuG6MzyoEQlehEcxMBI=";
  };

  meta = with lib; {
    description = "A set of nit-picky rules that aim to point out and explain common mistakes in nixpkgs package pull requests";
    homepage = "https://github.com/jtojnar/nixpkgs-hammering";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };

  rust-checks = rustPlatform.buildRustPackage {
    pname = "nixpkgs-hammering-rust-checks";
    inherit version src meta;
    sourceRoot = "${src.name}/rust-checks";
    cargoHash = "sha256-GIheha/AYH0uD61ck6TcpDz1gh1o5UxL/ojeZ/kHI8E=";
  };
in

stdenv.mkDerivation {
  pname = "nixpkgs-hammering";

  inherit version src;

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [ python3 ];

  installPhase = ''
    runHook preInstall

    AST_CHECK_NAMES=$(find ${rust-checks}/bin -maxdepth 1 -type f -printf "%f:")

    install -Dt $out/bin tools/nixpkgs-hammer
    wrapProgram $out/bin/nixpkgs-hammer \
      --prefix PATH : ${lib.makeBinPath [ nix rust-checks ]} \
      --set AST_CHECK_NAMES ''${AST_CHECK_NAMES%:}

    cp -r lib overlays $out

    runHook postInstall
  '';

  meta = meta // {
    mainProgram = "nixpkgs-hammer";
  };
}
