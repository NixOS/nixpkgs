{ lib, rustPlatform, fetchFromGitHub }:
rustPlatform.buildRustPackage rec {
  pname = "nixpkgs-fmt";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-99rYdyDLAdY2JCy/x4wYksrV8mhKPERYjWNh4UOtYrk=";
  };

  cargoSha256 = "sha256-9XmCZwLzaX61HJWRSi7wf7BdLCOMFYIVXiDNYYfUTlk=";

  meta = with lib; {
    description = "Nix code formatter for nixpkgs";
    homepage = "https://nix-community.github.io/nixpkgs-fmt";
    license = licenses.asl20;
    maintainers = with maintainers; [ zimbatm ];
  };
}
