{ lib
, rustPlatform
, fetchCrate
, pkg-config
, libgit2
, openssl
, zlib
, stdenv
, Security
, SystemConfiguration
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-audit";
  version = "0.20.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-hzy+AVWGWzWYupllrLSryoi4rXPM0+G6WBlRbf03xA8=";
  };

  cargoHash = "sha256-OOkJGdqEHNVbgZZIjQupGaSs4tB52b7kPGLKELUocn4=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libgit2
    openssl
    zlib
  ] ++ lib.optionals stdenv.isDarwin [
    Security
    SystemConfiguration
  ];

  buildFeatures = [ "fix" ];

  # The tests require network access which is not available in sandboxed Nix builds.
  doCheck = false;

  meta = with lib; {
    description = "Audit Cargo.lock files for crates with security vulnerabilities";
    homepage = "https://rustsec.org";
    changelog = "https://github.com/rustsec/rustsec/blob/cargo-audit/v${version}/cargo-audit/CHANGELOG.md";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ basvandijk figsoda jk ];
  };
}
