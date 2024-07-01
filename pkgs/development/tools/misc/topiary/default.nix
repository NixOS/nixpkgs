{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
, nix-update-script
}:

rustPlatform.buildRustPackage rec {
  pname = "topiary";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "tweag";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-zt4uXkO6Y0Yc1Wt8l5O79oKbgNLrgip40ftD7UfUPwo=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "tree-sitter-bash-0.19.0" = "sha256-a0/KyHV2jUpytsZSHI7tVw8GfYnuqVjfs5KScLZkB0I=";
      "tree-sitter-facade-0.9.3" = "sha256-M/npshnHJkU70pP3I4WMXp3onlCSWM5mMIqXP45zcUs=";
      "tree-sitter-json-0.20.0" = "sha256-cyrea0Y13OVGkXbYE0Cwc7nUsDGEZyoQmPAS9wVuHw0=";
      "tree-sitter-nickel-0.0.1" = "sha256-aYsEx1Y5oDEqSPCUbf1G3J5Y45ULT9OkD+fn6stzrOU=";
      "tree-sitter-ocaml-0.20.4" = "sha256-j3Hv2qOMxeBNOW+WIgIYzG3zMIFWPQpoHe94b2rT+A8=";
      "tree-sitter-ocamllex-0.20.2" = "sha256-YhmEE7I7UF83qMuldHqc/fD/no/7YuZd6CaAIaZ1now=";
      "tree-sitter-query-0.1.0" = "sha256-5N7FT0HTK3xzzhAlk3wBOB9xlEpKSNIfakgFnsxEi18=";
      "tree-sitter-rust-0.20.4" = "sha256-seWoMuA87ZWCq3mUXopVeDCcTxX/Bh+B4PFLVa0CBQA=";
      "tree-sitter-toml-0.5.1" = "sha256-5nLNBxFeOGE+gzbwpcrTVnuL1jLUA0ZLBVw2QrOLsDQ=";
      "web-tree-sitter-sys-1.3.0" = "sha256-9rKB0rt0y9TD/HLRoB9LjEP9nO4kSWR9ylbbOXo2+2M=";
    };
  };

  cargoBuildFlags = [ "-p" "topiary-cli" ];
  cargoTestFlags = cargoBuildFlags;

  env.TOPIARY_LANGUAGE_DIR = "${placeholder "out"}/share/queries";

  postInstall = ''
    install -Dm444 queries/* -t $out/share/queries
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
