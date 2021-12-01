{ lib, rustPlatform, fetchFromGitHub }:
rustPlatform.buildRustPackage rec {
  pname = "nixpkgs-fmt";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = pname;
    rev = "v${version}";
    sha256 = "0dqirvn8pq6ssxjlf6rkqcsx6ndasws93lz2v9f9s01k9ny8x8mq";
  };

  cargoSha256 = "0mm79hfh8p1rs02pkpcv25p59b24q1rymwh11yxry4d4f12b6aw0";

  meta = with lib; {
    description = "Nix code formatter for nixpkgs";
    homepage = "https://nix-community.github.io/nixpkgs-fmt";
    license = licenses.asl20;
    maintainers = with maintainers; [ zimbatm ];
  };
}
