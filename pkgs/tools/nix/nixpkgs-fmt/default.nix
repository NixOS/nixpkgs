{ lib, rustPlatform, fetchFromGitHub }:
rustPlatform.buildRustPackage rec {
  pname = "nixpkgs-fmt";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = pname;
    rev = "v${version}";
    sha256 = "07hnyx616dk03md00pmgpb5c2sp9w0n5l94s82arair0kpi0ncy0";
  };

  cargoSha256 = "0wfx7shsdqrwbnzr2a0fnly1kd93mxbm96zjq5pzrq94lphkhqhz";

  meta = with lib; {
    description = "Nix code formatter for nixpkgs";
    homepage = "https://nix-community.github.io/nixpkgs-fmt";
    license = licenses.asl20;
    maintainers = with maintainers; [ zimbatm ];
  };
}
