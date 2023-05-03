{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-expand";
  version = "1.0.48";

  src = fetchFromGitHub {
    owner = "dtolnay";
    repo = pname;
    rev = version;
    sha256 = "sha256-AdL14usCV4iHkrSHcNI6Jg8xeI3ZQxOABLCOCBd+Isw=";
  };

  cargoHash = "sha256-7sMKstWRAXFqBaEBLbetGH0l+9N4PchZ4IYshjmtxns=";

  meta = with lib; {
    description = "A utility and Cargo subcommand designed to let people expand macros in their Rust source code";
    homepage = "https://github.com/dtolnay/cargo-expand";
    changelog = "https://github.com/dtolnay/cargo-expand/releases/tag/${version}";
    license = with licenses; [ mit asl20 ];
    maintainers = with maintainers; [ figsoda xrelkd ];
  };
}
