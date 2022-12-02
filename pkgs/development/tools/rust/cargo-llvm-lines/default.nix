{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-llvm-lines";
  version = "0.4.22";

  src = fetchFromGitHub {
    owner = "dtolnay";
    repo = pname;
    rev = version;
    sha256 = "sha256-fQhYcY5b/KxDEbZws6IPq0EvVynWpQ8d1TJ2isTSwYQ=";
  };

  cargoSha256 = "sha256-aU+B/QrpKVtY/u53zS0q7/iNM0Z6xRMH3BPNmHd8Yps=";

  meta = with lib; {
    description = "Count the number of lines of LLVM IR across all instantiations of a generic function";
    homepage = "https://github.com/dtolnay/cargo-llvm-lines";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ figsoda ];
  };
}
