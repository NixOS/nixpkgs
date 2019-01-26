{ stdenv, fetchFromGitHub, rustPlatform, darwin }:

rustPlatform.buildRustPackage rec {
  name = "rustfmt-${version}";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "rust-lang";
    repo = "rustfmt";
    rev = "${version}";
    sha256 = "17ady2zq4jcbgawgpfszrkp6kxabb2f261g82y2az7nfax1h1pwy";
  };

  cargoSha256 = "0v8iq50h9368kai3m710br5cxc3p6mpbwz1v6gaf5802n48liqs8";

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
