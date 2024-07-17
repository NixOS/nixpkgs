{
  lib,
  fetchFromGitHub,
  rustPlatform,
  stdenv,
  makeWrapper,
  python3,
  nix,
  unstableGitUpdater,
}:

let
  version = "unstable-2024-03-25";

  src = fetchFromGitHub {
    owner = "jtojnar";
    repo = "nixpkgs-hammering";
    rev = "6851ecea8c6da45870b7c06d6495cba3fb2d7c7c";
    hash = "sha256-kr3zMr7aWt4W/+Jcol5Ctiq0KjXSxViPhGtyqvX9dqE=";
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
    cargoHash = "sha256-QrtAalZClNc0ZN6iNqN9rFRQ7w68lEZPV5e25uXYToA=";
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
      --prefix PATH : ${
        lib.makeBinPath [
          nix
          rust-checks
        ]
      } \
      --set AST_CHECK_NAMES ''${AST_CHECK_NAMES%:}

    cp -r lib overlays $out

    runHook postInstall
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = meta // {
    mainProgram = "nixpkgs-hammer";
  };
}
