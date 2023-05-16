{ lib, stdenv, rustPlatform, fetchFromGitHub, Security }:

rustPlatform.buildRustPackage rec {
  pname = "wagyu";
  version = "0.6.1";

  src = fetchFromGitHub {
<<<<<<< HEAD
    owner = "AleoHQ";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-ltWNKB3DHtwVVzJyvRWj2I8rjsl7ru2i/RCO9yiQhpg=";
  };

  cargoHash = "sha256-8dbeSHN6+1jLdVA9QxNAy7Y6EX7wflpQI72kqZAEVIE=";
=======
    owner = "ArgusHQ";
    repo = pname;
    rev = "v${version}";
    sha256 = "1646j0lgg3hhznifvbkvr672p3yqlcavswijawaxq7n33ll8vmcn";
  };

  cargoSha256 = "10al0j8ak95x4d85lzphgq8kmdnb809l6gahfp5miyvsfd4dxmpi";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  buildInputs = lib.optional stdenv.isDarwin Security;

  meta = with lib; {
    description = "Rust library for generating cryptocurrency wallets";
<<<<<<< HEAD
    homepage = "https://github.com/AleoHQ/wagyu";
=======
    homepage = "https://github.com/ArgusHQ/wagyu";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = with licenses; [ mit asl20 ];
    maintainers = [ maintainers.offline ];
  };
}
