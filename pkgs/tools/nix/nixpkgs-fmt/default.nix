{ lib, rustPlatform, fetchFromGitHub, fetchpatch }:
rustPlatform.buildRustPackage rec {
  pname = "nixpkgs-fmt";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-rO30/B+mH/ZOEH8IF2fF4uHK7XQqyR4zIDueHnmNMHA=";
  };

  cargoSha256 = "sha256-fP/8yDg+W7hiWGucbRr338y9PEDTb2bdq71JKE6M8OM=";

  meta = with lib; {
    description = "Nix code formatter for nixpkgs";
    homepage = "https://nix-community.github.io/nixpkgs-fmt";
    license = licenses.asl20;
    maintainers = with maintainers; [ zimbatm ];
  };
}
