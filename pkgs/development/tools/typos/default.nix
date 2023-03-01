{ fetchFromGitHub, rustPlatform, lib }:

rustPlatform.buildRustPackage rec {
  pname = "typos";
  version = "1.13.14";

  src = fetchFromGitHub {
    owner = "crate-ci";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-9p5h58fXENaZCVpDX5b/FqK0i5bL/M3vP+8jKYLQDh0=";
  };

  cargoHash = "sha256-IJi8FfwBMTTJRdBA6ydpD4yQWrEVnavxgiWxRCDoAOI=";

  meta = with lib; {
    description = "Source code spell checker";
    homepage = "https://github.com/crate-ci/typos/";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = [ maintainers.mgttlinger ];
  };
}
