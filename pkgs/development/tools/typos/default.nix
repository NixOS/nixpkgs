{ fetchFromGitHub, rustPlatform, lib }:

rustPlatform.buildRustPackage rec {
  pname = "typos";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "crate-ci";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-7L+hRr+/sphH4fq4vX7lI9KR6Tks1uLveSJ/wLqO1Ek=";
  };

  cargoSha256 = "sha256-AxhFQxtT3PfG3Y9nJlp8n4HjaOXxs9KDPY9Ha5Lr4VE=";

  meta = with lib; {
    description = "Source code spell checker";
    homepage = "https://github.com/crate-ci/typos/";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = [ maintainers.mgttlinger ];
  };
}
