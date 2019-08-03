{ stdenv, lib, darwin
, rustPlatform, fetchFromGitHub
, openssl, pkgconfig }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-edit";
  version = "0.3.3";

  src = fetchFromGitHub {
    owner = "killercup";
    repo = pname;
    rev = "v${version}";
    sha256 = "05b64bm9441crw74xlywjg2y3psljk2kf9xsrixaqwbnnahi0mm5";
  };

  cargoSha256 = "1hjjw3i35vqr6nxsv2m3izq4x8c2a6wvl5c2kjlpg6shy9j2mjaa";

  nativeBuildInputs = lib.optional (!stdenv.isDarwin) pkgconfig;
  buildInputs = lib.optional (!stdenv.isDarwin) openssl;
  propagatedBuildInputs = lib.optional stdenv.isDarwin darwin.apple_sdk.frameworks.Security;

  meta = with lib; {
    description = "A utility for managing cargo dependencies from the command line";
    homepage = https://github.com/killercup/cargo-edit;
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ gerschtli jb55 ];
    platforms = platforms.all;
  };
}
