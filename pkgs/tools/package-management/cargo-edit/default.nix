{ stdenv, lib, darwin
, rustPlatform, fetchFromGitHub
, openssl, pkgconfig }:

rustPlatform.buildRustPackage rec {
  name = "cargo-edit-${version}";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "killercup";
    repo = "cargo-edit";
    rev = "v${version}";
    sha256 = "0g3dikwk6n48dmhx9qchmzyrhcr40242lhvlcyk1nqbpvs3b51fm";
  };

  cargoSha256 = "1bq0mjn44f0sn94nb9wqal4swhkzn7f3vbk5jyay4v3wqfz1gb7r";

  nativeBuildInputs = lib.optional (!stdenv.isDarwin) pkgconfig;
  buildInputs = lib.optional (!stdenv.isDarwin) openssl;
  propagatedBuildInputs = lib.optional stdenv.isDarwin darwin.apple_sdk.frameworks.Security;

  patches = [ ./disable-network-based-test.patch ];

  meta = with lib; {
    description = "A utility for managing cargo dependencies from the command line";
    homepage = https://github.com/killercup/cargo-edit;
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ gerschtli jb55 ];
    platforms = platforms.all;
  };
}
