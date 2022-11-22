{ fetchFromGitHub, rustPlatform, lib }:

rustPlatform.buildRustPackage rec {
  pname = "typos";
  version = "1.13.0";

  src = fetchFromGitHub {
    owner = "crate-ci";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-/+M+yR28mUA3iJ8wJlsL5cNRHn19yypUpG/bcfFtwVQ=";
  };

  cargoHash = "sha256-GeEQ00r7GYm4goeCWGXg5m+d3eaM2eBJtuip09a1OV0=";

  meta = with lib; {
    description = "Source code spell checker";
    homepage = "https://github.com/crate-ci/typos/";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = [ maintainers.mgttlinger ];
  };
}
