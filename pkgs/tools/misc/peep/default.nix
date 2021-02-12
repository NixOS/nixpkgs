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
  cargoSha256 = "0hl6qkc0sy820xwrkdrlknwn0m7qq5cjyb3yh15jqv4z3r7r901d";

  meta = with lib; {
    description = "The CLI text viewer tool that works like less command on small pane within the terminal window";
    license = licenses.mit;
    homepage = "https://github.com/ryochack/peep";
    maintainers = with maintainers; [ ma27 ];
  };
}
