{ stdenv, fetchFromGitHub, rustPlatform
, openssh, openssl, pkgconfig, cmake, zlib, curl, libiconv }:

rustPlatform.buildRustPackage rec {
  name = "rls-${version}";
  # with rust 1.x you can only build rls version 1.x.y
  version = "1.34.0";

  src = fetchFromGitHub {
    owner = "rust-lang";
    repo = "rls";
    rev = "0d6f53e1a4adbaf7d83cdc0cb54720203fcb522e";
    sha256 = "1aabs0kr87sp68n9893im5wz21dicip9ixir9a9l56nis4qxpm7i";
  };

  cargoSha256 = "16r9rmjhb0dbdgx9qf740nsckjazz4z663vaajw5z9i4qh0jsy18";

  # a nightly compiler is required unless we use this cheat code.
  RUSTC_BOOTSTRAP=1;

  # clippy is hard to build with stable rust so we disable clippy lints
  cargoBuildFlags = [ "--no-default-features" ];

  nativeBuildInputs = [ pkgconfig cmake ];
  buildInputs = [ openssh openssl curl zlib libiconv ];

  doCheck = true;
  # the default checkPhase has no way to pass --no-default-features
  checkPhase = ''
    runHook preCheck

    # client tests are flaky
    rm tests/client.rs

    echo "Running cargo test"
    cargo test --no-default-features
    runHook postCheck
  '';

  meta = with stdenv.lib; {
    description = "Rust Language Server - provides information about Rust programs to IDEs and other tools";
    homepage = https://github.com/rust-lang/rls/;
    license = licenses.mit;
    maintainers = with maintainers; [ symphorien ];
    platforms = platforms.all;
  };
}
