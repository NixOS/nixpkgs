{ lib
, fetchFromGitHub
, rustPlatform
, stdenv
, makeWrapper
, python3
, nix
}:

let
  version = "unstable-2023-03-09";

  src = fetchFromGitHub {
    owner = "jtojnar";
    repo = "nixpkgs-hammering";
    rev = "243b81c687aac33d6716957c0cd2235c81631044";
    hash = "sha256-a57Ux6W2EvJBEHL6Op9Pz6Tvw/LRRk7uCMRvneXggEo=";
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
    cargoHash = "sha256-MFYMP6eQS0wJbHmTRKaKajSborzaW6dEfshtAZcP+xs=";
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

