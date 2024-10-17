{ lib
, rustPlatform
, fetchFromGitHub
, nix-update-script
}:

rustPlatform.buildRustPackage rec {
  pname = "topiary";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "tweag";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-5o5DvwUYAmODYlFCuDJwRvEkitgq2SFD9Wy0DRMjKsY=";
  };

  # lib.maintainers.toastal forked tree-sitter-bash to Codeberg @ 0.19.0 +
  # Topiary’s random extra post-0.19.0 commits to cherry-pick a
  # tree-sitter-bash upstream patch, b2959f8be16fa1e2ee88a560074527fdef05b328,
  # that removes the now-failing, previous submodule dependency. This is
  # reflected in the patch, ./Cargo.lock, & self.cargoLock.
  # See: https://github.com/tweag/topiary/issues/734
  cargoPatches = [
    ./tree-sitter-bash-update.patch
  ];

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "tree-sitter-bash-0.19.0" = "sha256-dBO5Sg4fSUesGgQqI1W3JtjGriqkh6ZyxuzwTmEWCQI=";
      "tree-sitter-css-0.20.0" = "sha256-IniaiBBx2pDD5nwJKfr5i9qvfvG+z8H21v14qk14M0g=";
      "tree-sitter-json-0.20.2" = "sha256-dVErHgsUDEN42wc/Gd68vQfVc8+/r/8No9KZk2GFzmY=";
      "tree-sitter-nickel-0.1.0" = "sha256-WuY6X1mnXdjiy4joIcY8voK2sqICFf0GvudulZ9lwqg=";
      "tree-sitter-ocaml-0.20.4" = "sha256-9Y/eZNsKkz8RKjMn5RIAPITkDQTWdSc/fBXzxMg1ViQ=";
      "tree-sitter-ocamllex-0.20.2" = "sha256-YhmEE7I7UF83qMuldHqc/fD/no/7YuZd6CaAIaZ1now=";
      "tree-sitter-query-0.2.0" = "sha256-H2QLsjl3/Kh0ojCf2Df38tb9KrM2InphEmtGd0J6+hM=";
      "tree-sitter-rust-0.20.4" = "sha256-egTxBuliboYbl+5N6Jdt960EMLByVmLqSmQLps3rEok=";
      "tree-sitter-toml-0.5.1" = "sha256-5nLNBxFeOGE+gzbwpcrTVnuL1jLUA0ZLBVw2QrOLsDQ=";
    };
  };

  cargoBuildFlags = [ "-p" "topiary-cli" ];
  cargoTestFlags = cargoBuildFlags;

  env.TOPIARY_LANGUAGE_DIR = "${placeholder "out"}/share/queries";

  postInstall = ''
    install -Dm444 topiary-queries/queries/* -t $out/share/queries
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Uniform formatter for simple languages, as part of the Tree-sitter ecosystem";
    mainProgram = "topiary";
    homepage = "https://github.com/tweag/topiary";
    changelog = "https://github.com/tweag/topiary/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
