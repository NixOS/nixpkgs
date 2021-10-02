{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, openssl
, pkg-config
, Security
, libiconv
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-audit";
  version = "0.15.2";

  src = fetchFromGitHub {
    owner = "RustSec";
    repo = "rustsec";
    rev = "cargo-audit%2Fv${version}";
    sha256 = "1j5ijrjhzqimamhj51qhpbaxx485hcxhaj64lknkn0xrda3apkx8";
  };

  cargoSha256 = "1qvrzaila3wbjmc7ri5asa3di2nzln78ys9innzd84fr36c90kkc";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
    libiconv
  ] ++ lib.optionals stdenv.isDarwin [
    Security
  ];

  # enables `cargo audit fix`
  cargoBuildFlags = [ "--features fix" ];

  # The tests require network access which is not available in sandboxed Nix builds.
  doCheck = false;

  meta = with lib; {
    description = "Audit Cargo.lock files for crates with security vulnerabilities";
    homepage = "https://rustsec.org";
    license = with licenses; [ mit asl20 ];
    maintainers = with maintainers; [ basvandijk ];
  };
}
