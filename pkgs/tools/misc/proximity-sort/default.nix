<<<<<<< HEAD
{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "proximity-sort";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "jonhoo";
    repo = "proximity-sort";
    rev = "v${version}";
    hash = "sha256-MRLQvspv6kjirljhAkk1KT+hPA4hdjA1b7RL9eEyglQ=";
  };

  cargoHash = "sha256-0hP6qa8d5CaqtBHCWBJ8UjtVJc6Z0GmL8DvdTWDMM8g=";
=======
{ lib, rustPlatform, fetchCrate }:

rustPlatform.buildRustPackage rec {
  pname = "proximity-sort";
  version = "1.2.0";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-So3cvL2F7wfcPVPEBspMLH4f5KSbVQeUKLJve/BXLA4=";
  };

  cargoSha256 = "sha256-VGxU3CD5pj0Hrt6nUbNU7eNEpNrzHp/WaFHAKPUz8DA=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Simple command-line utility for sorting inputs by proximity to a path argument";
    homepage = "https://github.com/jonhoo/proximity-sort";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ figsoda ];
  };
}
