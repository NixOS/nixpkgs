{ fetchFromGitHub, rustPlatform, lib }:

with rustPlatform;

buildRustPackage rec {
  pname = "tarssh";
  version = "0.7.0";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "Freaky";
    repo = pname;
    sha256 = "sha256-AoKc8VF6rqYIsijIfgvevwu+6+suOO7XQCXXgAPNgLk=";
  };

  cargoSha256 = "sha256-7X9klYVZ2yE8BPuLhzWkuT7VFpmdOZGSD0D1x3kBNEs=";

  meta = with lib; {
    description = "A simple SSH tarpit inspired by endlessh";
    homepage = "https://github.com/Freaky/tarssh";
    license = [ licenses.mit ];
    maintainers = with maintainers; [ sohalt ];
    platforms = platforms.unix ;
  };
}
