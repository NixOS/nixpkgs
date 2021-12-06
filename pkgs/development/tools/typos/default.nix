{ fetchFromGitHub, rustPlatform, lib }:

rustPlatform.buildRustPackage rec {
  pname = "typos";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "crate-ci";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-b81xopCkAUo9m9FBgL4v7OT+eZu4PNcF5QO1jXHVMT0=";
  };

  cargoSha256 = "sha256-3LFhUSg5cNtWPe8g43MsbGkmZR9BQdAT5m8k0eCBqIs=";

  meta = with lib; {
    description = "Source code spell checker";
    homepage = "https://github.com/crate-ci/typos/";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = [ maintainers.mgttlinger ];
  };
}
