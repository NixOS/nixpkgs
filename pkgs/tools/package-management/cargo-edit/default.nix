{ stdenv, lib, darwin
, rustPlatform, fetchFromGitHub
, openssl, pkgconfig }:

rustPlatform.buildRustPackage rec {
  name = "cargo-edit-${version}";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "killercup";
    repo = "cargo-edit";
    rev = "v${version}";
    sha256 = "0ngxyzqy5pfc0fqbvqw7kd40jhqzp67qvpzvh3yggk9yxa1jzsp0";
  };

  cargoSha256 = "1j7fqswdx6f2i5wr0pdavdvcv18j1l27a8ighr75p7f54apa27l8";

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
