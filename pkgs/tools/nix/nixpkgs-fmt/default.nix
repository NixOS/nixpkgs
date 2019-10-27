{ lib, rustPlatform, fetchFromGitHub }:
rustPlatform.buildRustPackage rec {
  pname = "nixpkgs-fmt";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = pname;
    rev = "v${version}";
    sha256 = "18kvsgl3kpla33dp1nbpd1kdgndfqcmlwwpjls55fp4mlczf8lcx";
  };

  cargoSha256 = "0wfx7shsdqrwbnzr2a0fnly1kd93mxbm96zjq5pzrq94lphkhqhz";

  meta = with lib; {
    description = "Nix code formatter for nixpkgs";
    homepage = "https://nix-community.github.io/nixpkgs-fmt";
    license = licenses.asl20;
    maintainers = with maintainers; [ zimbatm ];
  };
}
