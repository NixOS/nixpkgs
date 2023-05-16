{ lib
, rustPlatform
, fetchFromGitHub
, gmp
, mpfr
, libmpc
}:

rustPlatform.buildRustPackage rec {
  pname = "kalker";
<<<<<<< HEAD
  version = "2.0.4";
=======
  version = "2.0.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "PaddiM8";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-8tJi4PRGhNCndiMRdZUvCSdx/+p9OhJyJ3AbD+PucSo=";
  };

  cargoHash = "sha256-rGy4tkjjPiV2lpdOtfqjsXgBgi/x+45K4KeUDhyfQoA=";
=======
    sha256 = "sha256-Pj3rcjEbUt+pnmbOZlv2JIvUhVdeiXYDKc5FED6qO7E=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
  };
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  buildInputs = [ gmp mpfr libmpc ];

  outputs = [ "out" "lib" ];

<<<<<<< HEAD
  # Cargo.lock is outdated
  preConfigure = ''
    cargo metadata --offline
=======
  postPatch = ''
    ln -s ${./Cargo.lock} Cargo.lock
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  '';

  postInstall = ''
    moveToOutput "lib" "$lib"
  '';

<<<<<<< HEAD
  env.CARGO_FEATURE_USE_SYSTEM_LIBS = "1";
=======
  CARGO_FEATURE_USE_SYSTEM_LIBS = "1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    homepage = "https://kalker.strct.net";
    changelog = "https://github.com/PaddiM8/kalker/releases/tag/v${version}";
    description = "A command line calculator";
    longDescription = ''
      A command line calculator that supports math-like syntax with user-defined
      variables, functions, derivation, integration, and complex numbers
    '';
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda lovesegfault ];
  };
}
