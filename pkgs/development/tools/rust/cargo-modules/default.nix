{ lib, rustPlatform, fetchFromGitHub, stdenv, darwin }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-modules";
<<<<<<< HEAD
  version = "0.9.2";
=======
  version = "0.8.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "regexident";
    repo = pname;
    rev = version;
<<<<<<< HEAD
    hash = "sha256-3yvrIUvAlnAjEMnBTgDTY8gRW7rILu2Yns/A7lse2Qw=";
  };

  cargoHash = "sha256-Coh+gg2s4esdByQG6iNlG/VqftP+Gg0qaPoPArim1yQ=";
=======
    sha256 = "sha256-hbhj+D/zJDmRtPuEfg6ECvbfi2P7ecoiJASE8UXs9UE=";
  };

  cargoSha256 = "sha256-ydL2LQVewDmTsMWWAvTXSEp2bkfZdCSBxCIY8+DnABQ=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.CoreServices
  ];

  meta = with lib; {
    description = "A cargo plugin for showing a tree-like overview of a crate's modules";
    homepage = "https://github.com/regexident/cargo-modules";
    changelog = "https://github.com/regexident/cargo-modules/blob/${version}/CHANGELOG.md";
    license = with licenses; [ mpl20 ];
<<<<<<< HEAD
    maintainers = with maintainers; [ figsoda rvarago matthiasbeyer ];
=======
    maintainers = with maintainers; [ figsoda rvarago ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
