{ lib, rustPlatform, fetchFromGitHub }:
rustPlatform.buildRustPackage rec {
  pname = "nixpkgs-fmt";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = pname;
    rev = "v${version}";
    sha256 = "0b9wwv77bpq24yxky44ndgvxsx2zgsl15lvl6wklbkr41mwz3xis";
  };

  cargoSha256 = "1vv2gypbmgd9lksrk5h2z3agcs1269p1i3im9529nhcsl62ckj7n";

  meta = with lib; {
    description = "Nix code formatter for nixpkgs";
    homepage = "https://nix-community.github.io/nixpkgs-fmt";
    license = licenses.asl20;
    maintainers = with maintainers; [ zimbatm ];
  };
}
