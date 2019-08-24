{ lib, rustPlatform, fetchFromGitHub }:
rustPlatform.buildRustPackage rec {
  pname = "nixpkgs-fmt";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = pname;
    rev = "v${version}";
    sha256 = "0sa0263pkpi423f1rdyg90axw9sdmgj8ma1mza0v46qzkwynwgh3";
  };

  cargoSha256 = "0p3qa1asdvw2npav4281lzndjczrzac6fr8z4y61m7rbn363s8sa";

  meta = with lib; {
    description = "Nix code formatter for nixpkgs";
    homepage = "https://nix-community.github.io/nixpkgs-fmt";
    license = licenses.asl20;
    maintainers = with maintainers; [ zimbatm ];
  };
}
