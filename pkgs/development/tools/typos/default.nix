{ fetchFromGitHub, rustPlatform, lib }:

rustPlatform.buildRustPackage rec {
  pname = "typos";
  version = "1.13.10";

  src = fetchFromGitHub {
    owner = "crate-ci";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-+TNKHyLqW/R/YEpynr4twvQpgeOxbyIlgQjaQarSB8M=";
  };

  cargoHash = "sha256-7D9oyQK9VWOSAI9jSYZn7t8ll4sILpugroLWlST4Eok=";

  meta = with lib; {
    description = "Source code spell checker";
    homepage = "https://github.com/crate-ci/typos/";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = [ maintainers.mgttlinger ];
  };
}
