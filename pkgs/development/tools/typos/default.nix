{ fetchFromGitHub, rustPlatform, lib }:

rustPlatform.buildRustPackage rec {
  pname = "typos";
  version = "1.3.5";

  src = fetchFromGitHub {
    owner = "crate-ci";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-zL9Ylrl541RCSOliH+X7TfvRZyEXvISsH3N1agjoC8U=";
  };

  cargoSha256 = "sha256-qc32MX56/0JaHx/x/5em3SoNi6YM5nduVLrDOQbMZDg=";

  meta = with lib; {
    description = "Source code spell checker";
    homepage = "https://github.com/crate-ci/typos/";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = [ maintainers.mgttlinger ];
  };
}
