{ stdenv, fetchFromGitHub, rustPlatform, Security }:

rustPlatform.buildRustPackage rec {
  pname = "rust-cbindgen";
  version = "0.14.4";

  src = fetchFromGitHub {
    owner = "eqrion";
    repo = "cbindgen";
    rev = "v${version}";
    sha256 = "06bis9kk3r0gishzmsq5wk3vv8r78ggk4m800562q2yhnhc37lfd";
  };

  cargoSha256 = "0x8lxlik4n8rmlydcp0vqyiqwqm98cgwvw3h5hm2zviv8v0y8jnr";

  buildInputs = stdenv.lib.optional stdenv.isDarwin Security;

  checkFlags = [
    # https://github.com/eqrion/cbindgen/issues/338
    "--skip test_expand"
  ];

  meta = with stdenv.lib; {
    description = "A project for generating C bindings from Rust code";
    homepage = "https://github.com/eqrion/cbindgen";
    license = licenses.mpl20;
    maintainers = with maintainers; [ jtojnar andir ];
  };
}
