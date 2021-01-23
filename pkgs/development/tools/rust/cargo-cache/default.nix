{ lib, stdenv, fetchFromGitHub, rustPlatform, libiconv, Security }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-cache";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "matthiaskrgr";
    repo = pname;
    rev = version;
    sha256 = "sha256-SqhGwm2VZW6ZUYyxN940fi/YLJGAZikjJCIq0GbljtY=";
  };

  cargoSha256 = "sha256-sZxkEQBZ2PJXSvwcA+IL7uW/gcnzuzRcDklNW5vpzWg=";

  buildInputs = lib.optionals stdenv.isDarwin [ libiconv Security ];

  checkFlagsArray = [ "offline_tests" ];

  meta = with lib; {
    description = "Manage cargo cache (\${CARGO_HOME}, ~/.cargo/), print sizes of dirs and remove dirs selectively";
    homepage = "https://github.com/matthiaskrgr/cargo-cache";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ Br1ght0ne ];
  };
}
