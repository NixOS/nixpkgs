{ fetchFromGitHub, rustPlatform, lib }:

rustPlatform.buildRustPackage rec {
  pname = "typos";
  version = "1.13.16";

  src = fetchFromGitHub {
    owner = "crate-ci";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-3LJkWpksI9nep7QtEJdiEUZmwrWLyG/JKdu9YQh3KVk=";
  };

  cargoHash = "sha256-Wqikf248nZE2iQ6zU4bvz10PL/Z/WJ1srImi+bZ8s5w=";

  meta = with lib; {
    description = "Source code spell checker";
    homepage = "https://github.com/crate-ci/typos/";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = [ maintainers.mgttlinger ];
  };
}
