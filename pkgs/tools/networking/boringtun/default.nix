{ stdenv, fetchFromGitHub, rustPlatform, darwin }:

rustPlatform.buildRustPackage rec {
  pname = "boringtun";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "cloudflare";
    repo = pname;
    rev = "v${version}";
    sha256 = "1mijy51hd8c4as9g4ivpfxismc9m5m3nhibfvclh3wrlcmp1ha9c";
  };

  cargoSha256 = "1gvmshwg9b486933vfgkg2r8nn6w6dyz42hqjy74p785fcg0v5hs";

  buildInputs = stdenv.lib.optional stdenv.isDarwin darwin.apple_sdk.frameworks.Security;

  # Testing this project requires sudo, Docker and network access, etc.
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Userspace WireGuard® implementation in Rust";
    homepage = https://github.com/cloudflare/boringtun;
    license = licenses.bsd3;
    maintainers = with maintainers; [ xrelkd marsam ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
