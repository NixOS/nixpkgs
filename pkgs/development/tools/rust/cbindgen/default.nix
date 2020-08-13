{ stdenv, fetchFromGitHub, rustPlatform, Security }:

rustPlatform.buildRustPackage rec {
  pname = "rust-cbindgen";
  version = "0.14.3";

  src = fetchFromGitHub {
    owner = "eqrion";
    repo = "cbindgen";
    rev = "v${version}";
    sha256 = "0pw55334i10k75qkig8bgcnlsy613zw2p5j4xyz8v71s4vh1a58j";
  };

  cargoSha256 = "0088ijnjhqfvdb1wxy9jc7hq8c0yxgj5brlg68n9vws1mz9rilpy";

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
