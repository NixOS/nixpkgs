{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "foundry";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "foundry-rs";
    repo = pname;
    rev = "4c4480722be5e86ff6708cf341bff75988b410fc";
    hash = "sha256-XdT1KBl/VqUPg9Hl6XCP0aIHw7NZSfVbTNOisdfztx4=";
  };

  # cargoSha256 = lib.fakeSha256;
  cargoSha256 = "sha256-k8D6jrGyFF4Cnl7HEvWsbHCcxdyfZTpzvfcbL3OFBJc=";

  meta = with lib; {
    description = "Foundry is a blazing fast, portable and modular toolkit for Ethereum application development written in Rust.";
    homepage = "https://github.com/foundry-rs/foundry";
    license = licenses.mit;
    maintainers = [ ];
  };
}
