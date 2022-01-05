{ lib, stdenv, fetchFromGitHub, rustPlatform, libiconv, Security }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-cache";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "matthiaskrgr";
    repo = pname;
    rev = version;
    sha256 = "sha256-MPU+hmYfmWftVEkdT/sZx9ESgCPTb7m4lEnYf5bOSYU=";
  };

  cargoSha256 = "sha256-6Ffgg5/B1IFnTlSjzhAsnhxz8jBcgk01RIkwgLqlsvc=";

  buildInputs = lib.optionals stdenv.isDarwin [ libiconv Security ];

  checkFlagsArray = [ "offline_tests" ];

  meta = with lib; {
    description = "Manage cargo cache (\${CARGO_HOME}, ~/.cargo/), print sizes of dirs and remove dirs selectively";
    homepage = "https://github.com/matthiaskrgr/cargo-cache";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ Br1ght0ne ];
  };
}
