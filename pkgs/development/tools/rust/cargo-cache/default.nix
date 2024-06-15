{ lib, stdenv, fetchFromGitHub, rustPlatform, libiconv, Security }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-cache";
  version = "0.8.3";

  src = fetchFromGitHub {
    owner = "matthiaskrgr";
    repo = pname;
    rev = version;
    sha256 = "sha256-q9tYKXK8RqiqbDZ/lTxUI1Dm/h28/yZR8rTQuq+roZs=";
  };

  cargoSha256 = "sha256-275QREIcncgBk4ah/CivSz5N2m6s/XPCfp6JGChpr38=";

  buildInputs = lib.optionals stdenv.isDarwin [ libiconv Security ];

  checkFlagsArray = [ "offline_tests" ];

  meta = with lib; {
    description = "Manage cargo cache (\${CARGO_HOME}, ~/.cargo/), print sizes of dirs and remove dirs selectively";
    mainProgram = "cargo-cache";
    homepage = "https://github.com/matthiaskrgr/cargo-cache";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ Br1ght0ne matthiasbeyer ];
  };
}
