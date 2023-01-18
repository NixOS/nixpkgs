{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "foundry";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "EvanPiro";
    repo = pname;
    rev = "a3eeca23a139fded8e0ffa87615a3570c1d96c16";
    hash = "sha256-XdT1KBl/VqUPg9Hl6XCP0aIHw7NZSfVbTNOisdfztx4=";
  };

  # cargoSha256 = lib.fakeSha256;
  cargoSha256 = "sha256-k8D6jrGyFF4Cnl7HEvWsbHCcxdyfZTpzvfcbL3OFBJc=";

  meta = with lib; {
    description = "Foundry is a blazing fast, portable and modular toolkit for Ethereum application development written in Rust.";
    homepage = "https://github.com/EvanPiro/foundry";
    license = licenses.mit;
    maintainers = [ ];
  };
}
