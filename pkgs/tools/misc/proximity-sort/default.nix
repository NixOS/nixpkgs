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

  meta = with lib; {
    description = "Simple command-line utility for sorting inputs by proximity to a path argument";
    homepage = "https://github.com/jonhoo/proximity-sort";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "proximity-sort";
  };
}
