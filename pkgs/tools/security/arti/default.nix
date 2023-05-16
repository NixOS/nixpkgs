{ lib
, stdenv
, rustPlatform
, fetchFromGitLab
, pkg-config
, sqlite
, openssl
, CoreServices
}:

rustPlatform.buildRustPackage rec {
  pname = "arti";
<<<<<<< HEAD
  version = "1.1.8";
=======
  version = "1.1.4";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitLab {
    domain = "gitlab.torproject.org";
    group = "tpo";
    owner = "core";
    repo = "arti";
    rev = "arti-v${version}";
<<<<<<< HEAD
    sha256 = "sha256-+Y41jhMEzcNyA9U0zsvVyR9f1dEV94hFNR8SxiJ6hCk=";
  };

  cargoHash = "sha256-MF2WPUs0MvhN3MSmey7ziPPwZz8zkn2D3G2WDgXn+hs=";
=======
    sha256 = "sha256-+gd/3CKdZkH/zDqGGTna7S7LkadfpzfHlX2XfemZpoE=";
  };

  cargoHash = "sha256-YD7KAiZM3iG9FXXHo5c1WanF7tsJBAnGvb36gxEcV5k=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  nativeBuildInputs = lib.optionals stdenv.isLinux [ pkg-config ];

  buildInputs = [ sqlite ]
    ++ lib.optionals stdenv.isLinux [ openssl ]
    ++ lib.optionals stdenv.isDarwin [ CoreServices ];

  cargoBuildFlags = [ "--package" "arti" ];

  cargoTestFlags = [ "--package" "arti" ];

  meta = with lib; {
    description = "An implementation of Tor in Rust";
    homepage = "https://gitlab.torproject.org/tpo/core/arti";
    changelog = "https://gitlab.torproject.org/tpo/core/arti/-/raw/${src.rev}/CHANGELOG.md";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ marsam ];
  };
}
