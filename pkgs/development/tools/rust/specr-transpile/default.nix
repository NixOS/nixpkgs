{ lib
, rustPlatform
, fetchCrate
}:

rustPlatform.buildRustPackage rec {
  pname = "specr-transpile";
  version = "0.1.20";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-HXqUp80vPFwG0B+f/Zfem0gOHF/igmtxTvS1c8amLmo=";
  };

  cargoHash = "sha256-UCIXuVwMDCJkHQJtmRUw6EiGDYCF5DeUVxBrQM4lgxg=";

  meta = with lib; {
    description = "Converts Specr lang code to Rust";
    homepage = "https://github.com/RalfJung/minirust-tooling";
    license = with licenses; [ asl20 mit ];
    maintainers = with maintainers; [ figsoda ];
  };
}
