{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-license";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "onur";
    repo = "cargo-license";
    rev = "v${version}";
    sha256 = "05a2af84gjyfzhsln0afg16h02pr56jng4xlsg21hicyi1kxjwlf";
  };

  cargoPatches = [ ./add-Cargo.lock.patch ];

  cargoSha256 = "1hb1ja986s5lv9ashspy74xz7zk5a9rmpv31wvzzi2c7s1nnm2yk";

  meta = with lib; {
    description = "Cargo subcommand to see license of dependencies";
    homepage = "https://github.com/onur/cargo-license";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ basvandijk ];
  };
}
