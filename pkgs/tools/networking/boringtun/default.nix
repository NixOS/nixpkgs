{ lib, stdenv, fetchFromGitHub, rustPlatform, darwin }:

rustPlatform.buildRustPackage rec {
  pname = "boringtun";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "cloudflare";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-fZchh02CsVC5sdnR3blojslsKi7OxFcblHMuyuHsH/4=";
  };

  cargoSha256 = "sha256-iJbzvhRPVDHXqianQ6UbmYEfmZCS/obxFZV/PsJMhD0=";

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
