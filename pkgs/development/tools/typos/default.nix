{ fetchFromGitHub, rustPlatform, lib }:

rustPlatform.buildRustPackage rec {
  pname = "typos";
  version = "1.11.1";

  src = fetchFromGitHub {
    owner = "crate-ci";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-jQmihZl1mKBHg7HLKAbe9uuL1QM+cF0beFj8htz0IOU=";
  };

  cargoHash = "sha256-bO9QMMJY+gQyV811qXdwiH1oxW+5Q+dZqG/oT35Eze4=";

  meta = with lib; {
    description = "Source code spell checker";
    homepage = "https://github.com/crate-ci/typos/";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = [ maintainers.mgttlinger ];
  };
}
