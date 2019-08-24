{ lib, rustPlatform, fetchFromGitHub }:
rustPlatform.buildRustPackage rec {
  pname = "nixpkgs-fmt";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = pname;
    rev = "v${version}";
    sha256 = "0nz4njmrwacizz9z89ligxr2gyggk65vq9cmd6s4hn133gajf2n1";
  };

  cargoSha256 = "0p3qa1asdvw2npav4281lzndjczrzac6fr8z4y61m7rbn363s8sa";

  meta = with lib; {
    description = "Nix code formatter for nixpkgs";
    homepage = "https://nix-community.github.io/nixpkgs-fmt";
    license = licenses.asl20;
    maintainers = with maintainers; [ zimbatm ];
  };
}
