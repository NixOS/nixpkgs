{ stdenv, fetchFromGitHub, rustPlatform, darwin }:

rustPlatform.buildRustPackage rec {
  name = "rustfmt-${version}";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "rust-lang";
    repo = "rustfmt";
    rev = "v${version}";
    sha256 = "153pas7d5fchkmiw6mkbhn75lv3y69k85spzmm5i4lqnq7f0yqap";
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
    broken = stdenv.isDarwin;
    platforms = platforms.all;
  };
}
