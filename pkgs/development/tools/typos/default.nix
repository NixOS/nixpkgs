{ fetchFromGitHub, rustPlatform, lib }:

rustPlatform.buildRustPackage rec {
  pname = "typos";
  version = "1.3.3";

  src = fetchFromGitHub {
    owner = "crate-ci";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-OyH+fwE6ISGVol/0i56OfGhRf5Rw6WGx55MBZUN2frg=";
  };

  cargoSha256 = "sha256-PH1LpdzeBGmMDP5l2dgRWcZo+PjA5LTNLLBqnMEeOZk=";

  meta = with lib; {
    description = "Source code spell checker";
    homepage = "https://github.com/crate-ci/typos/";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = [ maintainers.mgttlinger ];
  };
}
