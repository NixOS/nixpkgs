{ stdenv, fetchFromGitHub, rustPlatform, darwin }:

rustPlatform.buildRustPackage rec {
  name = "rustfmt-${version}";
  version = "0.99.5";

  src = fetchFromGitHub {
    owner = "rust-lang";
    repo = "rustfmt";
    rev = "${version}";
    sha256 = "1gx1bsyb0f94r3f88f1j3b4rcm2x6zppcfab1c5vgpsr2dr6ch28";
  };

  cargoSha256 = "1rs6jjm75ixxhrf8b3zn991xa5kfayxlf0b70zdx6wd4r6by7w2y";

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
