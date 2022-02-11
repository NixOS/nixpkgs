{ lib, stdenv, fetchFromGitHub, rustPlatform, libiconv, Security }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-cache";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "matthiaskrgr";
    repo = pname;
    rev = version;
    sha256 = "sha256-e9mT+OpPDTBtvQx3BVekr38azzD2DaT715wYLHYkjtk=";
  };

  cargoSha256 = "sha256-pVa7OLRlWMy7ZlLGTeePt86kK5y0OULOLYrq9GtOFRA=";

  buildInputs = lib.optionals stdenv.isDarwin [ libiconv Security ];

  checkFlagsArray = [ "offline_tests" ];

  meta = with lib; {
    description = "Manage cargo cache (\${CARGO_HOME}, ~/.cargo/), print sizes of dirs and remove dirs selectively";
    homepage = "https://github.com/matthiaskrgr/cargo-cache";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ Br1ght0ne ];
  };
}
