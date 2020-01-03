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

  cargoSha256 = "0ksxvbrx8d8d09i167mdrhz5m46nbr6l0vyn7xpdanmha31xiaz9";

  meta = with lib; {
    description = "Cargo subcommand to see license of dependencies";
    homepage = "https://github.com/onur/cargo-license";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ basvandijk ];
    platforms = platforms.all;
  };
}
