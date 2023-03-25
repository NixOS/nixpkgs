{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-all-features";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "frewsxcv";
    repo = pname;
    rev = version;
    sha256 = "sha256-p9UQaqytqpD2u9X9zaTPIgVEloU2UbD/AxVERNs1Lt8=";
  };

  cargoSha256 = "sha256-krtuLFQlInqdv7j8v13/X3lL0JdaMsApb9Ga5muThgw=";

  meta = with lib; {
    description = "A Cargo subcommand to build and test all feature flag combinations";
    homepage = "https://github.com/frewsxcv/cargo-all-features";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ figsoda ];
  };
}
