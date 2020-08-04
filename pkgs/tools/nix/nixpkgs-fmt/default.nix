{ lib, rustPlatform, fetchFromGitHub, fetchpatch }:
rustPlatform.buildRustPackage rec {
  pname = "nixpkgs-fmt";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = pname;
    rev = "v${version}";
    sha256 = "1kkw87c63nx5pqsxcwn6iw27k02j9ls21zyhb5dvf0zaqd9sz7ad";
  };

  cargoSha256 = "1wybvm9qckx9cd656gx9zrbszmaj66ihh2kk6qqdb6maixcq5k0x";

  meta = with lib; {
    description = "Nix code formatter for nixpkgs";
    homepage = "https://nix-community.github.io/nixpkgs-fmt";
    license = licenses.asl20;
    maintainers = with maintainers; [ zimbatm ];
  };
}
