{ stdenv, fetchFromGitHub, rustPlatform, darwin }:

rustPlatform.buildRustPackage rec {
  name = "rustfmt-${version}";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "rust-lang";
    repo = "rustfmt";
    rev = "${version}";
    sha256 = "1l18ycbq3125sq8v3wgma630wd6kclarlf8f51cmi9blk322jg9p";
  };

  cargoSha256 = "1557783icdzlwn02c5zl4362yl85r5zj4nkjv80p6896yli9hk9h";

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
