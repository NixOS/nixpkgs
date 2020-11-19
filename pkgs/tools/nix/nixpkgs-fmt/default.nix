{ lib, rustPlatform, fetchFromGitHub, fetchpatch }:
rustPlatform.buildRustPackage rec {
  pname = "nixpkgs-fmt";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = pname;
    rev = "v${version}";
    sha256 = "0w1himwix7iv40rixj9afknwmqg2qmkif23z217gc7x63zyg9vdc";
  };

  cargoSha256 = "1qzhii72hjdxmgfncvyk80ybvk6zywd6v73bb1ibhnry734grzvw";

  meta = with lib; {
    description = "Nix code formatter for nixpkgs";
    homepage = "https://nix-community.github.io/nixpkgs-fmt";
    license = licenses.asl20;
    maintainers = with maintainers; [ zimbatm ];
  };
}
