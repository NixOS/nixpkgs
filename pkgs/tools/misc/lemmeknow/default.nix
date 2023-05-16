{ lib, rustPlatform, fetchCrate }:

rustPlatform.buildRustPackage rec {
  pname = "lemmeknow";
<<<<<<< HEAD
  version = "0.8.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-Q82tP4xNWAooFjHeJCFmuULnWlFbgca/9Y2lm8rVXKs=";
  };

  cargoHash = "sha256-slV9RxdFCEx1El7hngWGv+5CqDSQsU2ACF2nWQLOTU0=";
=======
  version = "0.7.0";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-rSuHFVUYpL1v5ba0q15mNEuAHzFF9tWxFs3zTJt5zcc=";
  };

  cargoSha256 = "sha256-x//spFPlmJJAIyI5RgnYlMORi4eCXc8p7iEJQ7Ayptw=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "A tool to identify anything";
    homepage = "https://github.com/swanandx/lemmeknow";
<<<<<<< HEAD
    changelog = "https://github.com/swanandx/lemmeknow/releases/tag/v${version}";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda Br1ght0ne ];
  };
}
