{ fetchFromGitHub, rustPlatform, lib }:

rustPlatform.buildRustPackage rec {
  pname = "typos";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "crate-ci";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-It112+60ze+5rvq3TYlIU+X4lJ4pgdCO7Gb1ADArDvY=";
  };

  cargoSha256 = "sha256-yiy1xLxCdjIzqXUlkxWoOZ7cPZzJgDuTUvNHpnnTnwE=";

  meta = with lib; {
    description = "Source code spell checker";
    homepage = "https://github.com/crate-ci/typos/";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = [ maintainers.mgttlinger ];
  };
}
