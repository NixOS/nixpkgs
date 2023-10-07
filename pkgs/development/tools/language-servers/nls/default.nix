{ lib
, rustPlatform
, nickel
, stdenv
}:

rustPlatform.buildRustPackage {
  pname = "nls";

  inherit (nickel) src version nativeBuildInputs;

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "topiary-0.2.3" = "sha256-DcmrQ8IuvUBDCBKKSt13k8rU8DJZWFC8MvxWB7dwiQM=";
      "tree-sitter-bash-0.20.3" = "sha256-zkhCk19kd/KiqYTamFxui7KDE9d+P9pLjc1KVTvYPhI=";
      "tree-sitter-facade-0.9.3" = "sha256-M/npshnHJkU70pP3I4WMXp3onlCSWM5mMIqXP45zcUs=";
      "tree-sitter-nickel-0.0.1" = "sha256-aYsEx1Y5oDEqSPCUbf1G3J5Y45ULT9OkD+fn6stzrOU=";
      "tree-sitter-query-0.1.0" = "sha256-5N7FT0HTK3xzzhAlk3wBOB9xlEpKSNIfakgFnsxEi18=";
      "web-tree-sitter-sys-1.3.0" = "sha256-9rKB0rt0y9TD/HLRoB9LjEP9nO4kSWR9ylbbOXo2+2M=";
    };
  };

  cargoBuildFlags = [ "-p nickel-lang-lsp" ];

  meta = {
    inherit (nickel.meta) homepage changelog license maintainers;
    description = "A language server for the Nickel programming language";
    longDescription = ''
      The Nickel Language Server (NLS) is a language server for the Nickel
      programming language. NLS offers error messages, type hints, and
      auto-completion right in your favorite LSP-enabled editor.
    '';
  };
}
