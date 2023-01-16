{ fetchFromGitHub, rustPlatform, lib }:

rustPlatform.buildRustPackage rec {
  pname = "typos";
  version = "1.13.7";

  src = fetchFromGitHub {
    owner = "crate-ci";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-9adccECtWty9GURjzUd6sPYn8qojGWzCrDIpUxswx4k=";
  };

  cargoHash = "sha256-5hg+w2IZOI6d06H7sAokO0v4b6ofxvak64v3he5n4LI=";

  meta = with lib; {
    description = "Source code spell checker";
    homepage = "https://github.com/crate-ci/typos/";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = [ maintainers.mgttlinger ];
  };
}
