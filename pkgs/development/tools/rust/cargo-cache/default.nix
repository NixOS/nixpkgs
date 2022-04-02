{ lib, stdenv, fetchFromGitHub, rustPlatform, libiconv, Security }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-cache";
  version = "0.8.2";

  src = fetchFromGitHub {
    owner = "matthiaskrgr";
    repo = pname;
    rev = version;
    sha256 = "sha256-1/h9o8ldxI/Q1E6AurGfZ1xruf12g1OO5QlzMJLcEGo=";
  };

  cargoSha256 = "sha256-yUa40j1yOrczCbp9IsL1e5FlHcSEeHPAmbrA8zpuTpI=";

  buildInputs = lib.optionals stdenv.isDarwin [ libiconv Security ];

  checkFlagsArray = [ "offline_tests" ];

  meta = with lib; {
    description = "Manage cargo cache (\${CARGO_HOME}, ~/.cargo/), print sizes of dirs and remove dirs selectively";
    homepage = "https://github.com/matthiaskrgr/cargo-cache";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ Br1ght0ne ];
  };
}
