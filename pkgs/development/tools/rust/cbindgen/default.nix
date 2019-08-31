{ stdenv, fetchFromGitHub, rustPlatform, Security }:

rustPlatform.buildRustPackage rec {
  name = "rust-cbindgen-${version}";
  version = "0.8.7";

  src = fetchFromGitHub {
    owner = "eqrion";
    repo = "cbindgen";
    rev = "v${version}";
    sha256 = "040rivayr0dgmrhlly5827c850xbr0j5ngiy6rvwyba5j9iv2x0y";
  };

  cargoSha256 = "1nig4891p7ii4z4f4j4d4pxx39f501g7yrsygqbpkr1nrgjip547";

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
