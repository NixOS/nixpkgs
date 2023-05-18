{ fetchFromGitHub, rustPlatform, lib }:

rustPlatform.buildRustPackage rec {
  pname = "typos";
  version = "1.14.9";

  src = fetchFromGitHub {
    owner = "crate-ci";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-dfUXH7MRTnHYSqNJzlT0fUn/Er0wrTARq3ZuOdWToow=";
  };

  cargoHash = "sha256-+u/3XtC/HxtAsX4dRf74u0BLh872Y2kK+BnbWqUnUdo=";

  meta = with lib; {
    description = "Source code spell checker";
    homepage = "https://github.com/crate-ci/typos/";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = [ maintainers.mgttlinger ];
  };
}
