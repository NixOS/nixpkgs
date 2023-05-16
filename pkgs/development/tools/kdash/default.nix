{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, pkg-config
, perl
, python3
, openssl
, xorg
, AppKit
}:

rustPlatform.buildRustPackage rec {
  pname = "kdash";
<<<<<<< HEAD
  version = "0.4.2";
=======
  version = "0.3.6";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "kdash-rs";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-PjkRE4JWDxiDKpENN/yDnO45CegxLPov/EhxnUbmpOg=";
=======
    sha256 = "sha256-dXkYHRB0VZ3FGe1Zu78ZzocaVV4zSGzxRMC0WOHiZrE=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ perl python3 pkg-config ];

  buildInputs = [ openssl xorg.xcbutil ]
    ++ lib.optional stdenv.isDarwin AppKit;

<<<<<<< HEAD
  cargoHash = "sha256-nCFXhAaVrIkm6XOSa1cDCxukbf/CVmwPEu6gk7VybVQ=";
=======
  cargoSha256 = "sha256-LWGoWFPZsTYa1hQnv1eNNmCKZsiLredvD6+kWanVEK0=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "A simple and fast dashboard for Kubernetes";
    homepage = "https://github.com/kdash-rs/kdash";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ matthiasbeyer ];
  };
}
