{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "peep";
  version = "0.1.4";

  src = fetchFromGitHub {
    owner = "ryochack";
    repo = "peep";
    rev = "v${version}";
    sha256 = "0c0fphnhq9vg9jjnkl35k56jbcnyz2ballsnkbm2xrh8vbyvk1av";
  };

  cargoPatches = [ ./0001-Add-Cargo.lock-by-running-cargo-vendor.patch ];
  cargoSha256 = "12jqhvf8kdi17c442hl8sfpgxhni07x59khjwyyn54bnwc5h3zf9";

  meta = with lib; {
    description = "The CLI text viewer tool that works like less command on small pane within the terminal window";
    license = licenses.mit;
    homepage = "https://github.com/ryochack/peep";
    maintainers = with maintainers; [ ];
  };
}
