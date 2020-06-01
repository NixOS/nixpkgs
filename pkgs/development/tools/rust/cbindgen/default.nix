{ stdenv, fetchFromGitHub, rustPlatform, Security }:

rustPlatform.buildRustPackage rec {
  pname = "rust-cbindgen";
  version = "0.14.2";

  src = fetchFromGitHub {
    owner = "eqrion";
    repo = "cbindgen";
    rev = "v${version}";
    sha256 = "15mk7q89rs723c7i9wwq4rrvakwh834wvrsmsnayji5k1kwaj351";
  };

  cargoSha256 = "03irndd48ck62chm4vmlcnfm98gwd86xm1ssq9glw3b3y0n6x845";

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
