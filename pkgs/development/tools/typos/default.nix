{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "typos";
  version = "1.15.0";

  src = fetchFromGitHub {
    owner = "crate-ci";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-SbWwrvfLawWoVuCG9b4PrA5cdc+DLqJw2uSF3oha9Po=";
  };

  cargoHash = "sha256-XLnN6kCjHntqZu80Uvm95pCabjR5QMvsumb+V002N2Y=";

  meta = with lib; {
    description = "Source code spell checker";
    homepage = "https://github.com/crate-ci/typos";
    changelog = "https://github.com/crate-ci/typos/blob/${src.rev}/CHANGELOG.md";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ figsoda mgttlinger ];
  };
}
