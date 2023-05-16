{ lib, rustPlatform, fetchCrate }:

rustPlatform.buildRustPackage rec {
  pname = "faketty";
<<<<<<< HEAD
  version = "1.0.13";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-jV5b6mB81Nz0Q+Toj5DTQq2QcM+EoQ7jRYV/OXgtemA=";
  };

  cargoHash = "sha256-9t1Km/ZXzxyO72CaWM81fWGcFkri7F+wMAVom0GV/YM=";
=======
  version = "1.0.12";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-1q1TOwKC2Tse/Ct/6Nw7YiOviJyBZAsOBEp3sT4N0ss=";
  };

  cargoSha256 = "sha256-x8+7sZJnA+kEwKAu8DBF8z7JhWjJ6ZFiLaQP8kFOt08=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  postPatch = ''
    patchShebangs tests/test.sh
  '';

  meta = with lib; {
    description = "A wrapper to execute a command in a pty, even if redirecting the output";
    homepage = "https://github.com/dtolnay/faketty";
<<<<<<< HEAD
    changelog = "https://github.com/dtolnay/faketty/releases/tag/${version}";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ figsoda ];
  };
}
