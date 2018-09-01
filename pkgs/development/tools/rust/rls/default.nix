{ stdenv, fetchFromGitHub, rustPlatform
, openssh, openssl, pkgconfig, cmake, zlib, curl }:

rustPlatform.buildRustPackage rec {
  name = "rls-${version}";
  # with rust 1.x you can only build rls version 1.x.y
  version = "1.31.7";

  src = fetchFromGitHub {
    owner = "rust-lang";
    repo = "rls";
    rev = version;
    sha256 = "0n33pf7sm31y55rllb8wv3mn75srspr4yj2y6cpcdyf15n47c8cf";
  };

  cargoSha256 = "0jcsggq4ay8f4vb8n6gh8z995icvvbjkzapxf6jq6qkg6jp3vv17";

  # a nightly compiler is required unless we use this cheat code.
  RUSTC_BOOTSTRAP=1;

  # clippy is hard to build with stable rust so we disable clippy lints
  cargoBuildFlags = [ "--no-default-features" ];

  nativeBuildInputs = [ pkgconfig cmake ];
  buildInputs = [ openssh openssl curl zlib ];

  doCheck = true;
  # the default checkPhase has no way to pass --no-default-features
  checkPhase = ''
    runHook preCheck
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
