{ stdenv, fetchFromGitHub, rustPlatform, darwin }:

rustPlatform.buildRustPackage rec {
  name = "rustfmt-${version}";
  version = "1.2.2";

  src = fetchFromGitHub {
    owner = "rust-lang";
    repo = "rustfmt";
    rev = "v${version}";
    sha256 = "1k9p6sp8q87flx9vzg46880ir7likvbydai3g6q76278h86rn0v8";
  };

  cargoSha256 = "08x6vy5v2vgrk3gsw3qcvv52a7hifsgcsnsg1phlk1ikaff21y4z";

  buildInputs = stdenv.lib.optional stdenv.isDarwin darwin.apple_sdk.frameworks.Security;

  # As of 1.0.0 and rustc 1.30 rustfmt requires a nightly compiler
  RUSTC_BOOTSTRAP = 1;

  # we run tests in debug mode so tests look for a debug build of
  # rustfmt. Anyway this adds nearly no compilation time.
  preCheck = ''
    cargo build
  '';

  meta = with stdenv.lib; {
    description = "A tool for formatting Rust code according to style guidelines";
    homepage = https://github.com/rust-lang-nursery/rustfmt;
    license = with licenses; [ mit asl20 ];
    maintainers = [ maintainers.globin ];
    platforms = platforms.all;
  };
}
