{ lib, rustPlatform, fetchFromGitHub }:
rustPlatform.buildRustPackage rec {
  pname = "nixpkgs-fmt";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = pname;
    rev = "v${version}";
    sha256 = "1iylldgyvrcarfigpbhicg6j6qyipfiqn7gybza7qajfzyprjqfa";
  };

  cargoSha256 = "1jxvy4w9jxv898wgqyj9bpkhnc7pkj9dxg5x0b39xsnkzl2lr239";

  meta = with lib; {
    description = "Nix code formatter for nixpkgs";
    homepage = "https://nix-community.github.io/nixpkgs-fmt";
    license = licenses.asl20;
    maintainers = with maintainers; [ zimbatm ];
  };
}
