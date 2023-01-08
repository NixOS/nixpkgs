{ fetchFromGitHub, rustPlatform, lib }:

rustPlatform.buildRustPackage rec {
  pname = "typos";
  version = "1.13.6";

  src = fetchFromGitHub {
    owner = "crate-ci";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-aaKjtxy0SVZB9/dcARmDkiiPM8XzwFHYqEctY3kfPWg=";
  };

  cargoHash = "sha256-tTArwBfxzbX6FJiOsAuyT6HRbdelp1txcmcDszACfn8=";

  meta = with lib; {
    description = "Source code spell checker";
    homepage = "https://github.com/crate-ci/typos/";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = [ maintainers.mgttlinger ];
  };
}
