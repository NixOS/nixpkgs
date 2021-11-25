{ fetchFromGitHub, rustPlatform, lib }:

rustPlatform.buildRustPackage rec {
  pname = "typos";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "crate-ci";
    repo = pname;
    rev = "v${version}";
    sha256 = "Y+sIyueLdREoq/NR6LwppyhWxB8s0iBjdFaDUSKnlRw=";
  };

  cargoSha256 = "3oqmiHH9QU8uHs9q2CgE0uTvfyaRxV3rFBxkXxC5/Tw=";

  meta = with lib; {
    description = "Source code spell checker";
    homepage = "https://github.com/crate-ci/typos/";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = [ maintainers.mgttlinger ];
  };
}
