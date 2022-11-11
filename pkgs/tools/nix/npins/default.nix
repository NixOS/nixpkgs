{ lib
, rustPlatform
, fetchFromGitHub
, nix-gitignore
, makeWrapper
, stdenv
, darwin
, callPackage

  # runtime dependencies
, nix # for nix-prefetch-url
, nix-prefetch-git
, git # for git ls-remote
}:

let
  runtimePath = lib.makeBinPath [ nix nix-prefetch-git git ];
  sources = (builtins.fromJSON (builtins.readFile ./sources.json)).pins;
in rustPlatform.buildRustPackage rec {
  pname = "npins";
  version = src.version;
  src = passthru.mkSource sources.npins;

  cargoSha256 = "sha256-NDu4nl4Os7Mgal8gBHC6bsZ2Z+Fqt0PlGdLHiPd/8T4=";

  buildInputs = lib.optional stdenv.isDarwin (with darwin.apple_sdk.frameworks; [ Security ]);
  nativeBuildInputs = [ makeWrapper ];

  # (Almost) all tests require internet
  doCheck = false;

  postFixup = ''
    wrapProgram $out/bin/npins --prefix PATH : "${runtimePath}"
  '';

  meta = with lib; {
    description = "Simple and convenient dependency pinning for Nix";
    homepage = "https://github.com/andir/npins";
    license = licenses.eupl12;
    maintainers = with maintainers; [ piegames ];
  };

  passthru.mkSource = callPackage ./source.nix {};
}
