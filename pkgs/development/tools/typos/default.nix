{ fetchFromGitHub, rustPlatform, lib }:

rustPlatform.buildRustPackage rec {
  pname = "typos";
  version = "1.10.1";

  src = fetchFromGitHub {
    owner = "crate-ci";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-CdmzGqqzMvLYAXJ2hpjoOQ8FA53PzGspWdjTFWlshYI=";
  };

  cargoHash = "sha256-X41CSz52S2M4rUsX/GiDGoBpZgUS8UNPvHg7rxbsG0k=";

  meta = with lib; {
    description = "Source code spell checker";
    homepage = "https://github.com/crate-ci/typos/";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = [ maintainers.mgttlinger ];
  };
}
