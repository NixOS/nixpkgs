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

  cargoSha256 = "1gda6m5g545fgx8ash96w408mxi5rb8hrv73c0xs0gx7hfyx5zcj";

  meta = with lib; {
    description = "Cargo subcommand to see license of dependencies";
    homepage = "https://github.com/onur/cargo-license";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ basvandijk ];
  };
}
