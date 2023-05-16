{ lib, stdenv, fetchFromGitHub, rustPlatform, Security }:

rustPlatform.buildRustPackage rec {
  pname = "worker-build";
<<<<<<< HEAD
  version = "0.0.18";
=======
  version = "0.0.16";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "cloudflare";
    repo = "workers-rs";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-z6m14IbMzgycwnQpA28e4taokDSVpfZOKIRmFIwLjbg=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "postgres-protocol-0.6.5" = "sha256-xLyaappu7ebtKOoHY49dvjDEcuRg8IOv1bNH9RxSUcM=";
    };
  };
=======
    sha256 = "sha256-8+ifSCfHYrS5iAa4fsujmofzicbwk/00VRNZvIkIc+E=";
  };

  cargoHash = "sha256-fj/l53AdgJXYz+IA45yfNYgSw7DKbBrGVyFCfbqxxq0=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  buildInputs = lib.optionals stdenv.isDarwin [ Security ];

  buildAndTestSubdir = "worker-build";

  # missing some module upstream to run the tests
  doCheck = false;

  meta = with lib; {
    description = "This is a tool to be used as a custom build command for a Cloudflare Workers `workers-rs` project.";
<<<<<<< HEAD
    homepage = "https://github.com/cloudflare/workers-rs";
=======
    homepage = "https://github.com/cloudflare/worker-rs";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ happysalada ];
  };
}
