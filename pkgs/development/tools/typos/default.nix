<<<<<<< HEAD
{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "typos";
  version = "1.16.11";
=======
{ fetchFromGitHub, rustPlatform, lib }:

rustPlatform.buildRustPackage rec {
  pname = "typos";
  version = "1.14.9";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "crate-ci";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-6CinLQ3wdVG1Ry7nskbC4JlhwT9rlJiP1oc4ks1t7Ts=";
  };

  cargoHash = "sha256-S7cMbnelsUfP8t93jqv0PY50fN/XtkphKhiKfe2fE/c=";

  meta = with lib; {
    description = "Source code spell checker";
    homepage = "https://github.com/crate-ci/typos";
    changelog = "https://github.com/crate-ci/typos/blob/${src.rev}/CHANGELOG.md";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ figsoda mgttlinger ];
=======
    hash = "sha256-dfUXH7MRTnHYSqNJzlT0fUn/Er0wrTARq3ZuOdWToow=";
  };

  cargoHash = "sha256-+u/3XtC/HxtAsX4dRf74u0BLh872Y2kK+BnbWqUnUdo=";

  meta = with lib; {
    description = "Source code spell checker";
    homepage = "https://github.com/crate-ci/typos/";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = [ maintainers.mgttlinger ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
