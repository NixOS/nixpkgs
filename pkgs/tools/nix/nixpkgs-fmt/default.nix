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

  cargoSha256 = "138aq64rb08s96q3xqcmvl3ax78rhjkwfa6v9iz8ywl32066gahb";

  meta = with lib; {
    description = "Nix code formatter for nixpkgs";
    homepage = "https://nix-community.github.io/nixpkgs-fmt";
    license = licenses.asl20;
    maintainers = with maintainers; [ zimbatm ];
  };
}
