{ lib, rustPlatform, fetchFromGitHub, rustfmt }:

rustPlatform.buildRustPackage rec {
  pname = "millet";
  version = "0.1.12";

  src = fetchFromGitHub {
    owner = "azdavis";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-dYX7G/oDSjQwW28njat6pdNobnFp5yE7rgUCPqbWLi0=";
  };

  cargoSha256 = "sha256-ve7V2G4rVQJshngxEFZWX8PtRxvZgeHP7XCgW4x1yyo=";

  nativeBuildInputs = [
    # Required for `syntax-gen` crate https://github.com/azdavis/language-util/blob/8ec2dc509c88951102ad3e751820443059a363af/crates/syntax-gen/src/util.rs#L37
    rustfmt
  ];

  cargoBuildFlags = [ "--package" "lang-srv" ];

  meta = with lib; {
    description = "A language server for Standard ML";
    homepage = "https://github.com/azdavis/millet";
    license = licenses.mit;
    maintainers = with maintainers; [ marsam ];
  };
}
