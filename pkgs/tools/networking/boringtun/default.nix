{ lib, stdenv, fetchFromGitHub, rustPlatform, darwin }:

rustPlatform.buildRustPackage rec {
  pname = "boringtun";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "cloudflare";
    repo = pname;
    rev = "boringtun-cli-${version}";
    sha256 = "sha256-s7Nl95VShBMD4Zid2LeRPftSx5R2G+4tHBXgrC1I7vU=";
  };

  cargoSha256 = "sha256-308zydrhOZS5h16DEp9ctrhtB2bv9Tmwutgj5+uc4Lw=";

  buildInputs = lib.optional stdenv.isDarwin darwin.apple_sdk.frameworks.Security;

  # Testing this project requires sudo, Docker and network access, etc.
  doCheck = false;

  meta = with lib; {
    description = "Userspace WireGuard® implementation in Rust";
    homepage = "https://github.com/cloudflare/boringtun";
    license = licenses.bsd3;
    maintainers = with maintainers; [ xrelkd marsam ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
