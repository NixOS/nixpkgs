{ stdenv, fetchFromGitHub, rustPlatform, Security }:

rustPlatform.buildRustPackage rec {
  name = "rust-cbindgen-${version}";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "eqrion";
    repo = "cbindgen";
    rev = "v${version}";
    sha256 = "1sh9kll3ky0d6chp7l7z8j91ckibxkfhi0v7imz2fgzzy2lbqy88";
  };

  cargoSha256 = "1cn84xai1n0f8xwwwwig93dawk73g1w6n6zm4axg5zl4vrmq4j6w";

  buildInputs = stdenv.lib.optional stdenv.isDarwin Security;

  # https://github.com/eqrion/cbindgen/issues/338
  RUSTC_BOOTSTRAP = 1;

  meta = with stdenv.lib; {
    description = "A project for generating C bindings from Rust code";
    homepage = https://github.com/eqrion/cbindgen;
    license = licenses.mpl20;
    maintainers = with maintainers; [ jtojnar andir ];
  };
}
