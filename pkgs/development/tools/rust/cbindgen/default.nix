{ stdenv, fetchFromGitHub, rustPlatform, Security }:

rustPlatform.buildRustPackage rec {
  name = "rust-cbindgen-${version}";
  version = "0.8.3";

  src = fetchFromGitHub {
    owner = "eqrion";
    repo = "cbindgen";
    rev = "v${version}";
    sha256 = "08zlnk1k1nddjciccfdcplxqngsnz6ml3zxm57mijabzybry8zz1";
  };

  cargoSha256 = "00j5nm491zil6kpjns31qyd6z7iqd77b5qp4h7149s70qjwfq2cb";

  buildInputs = stdenv.lib.optional stdenv.isDarwin Security;

  meta = with stdenv.lib; {
    description = "A project for generating C bindings from Rust code";
    homepage = https://github.com/eqrion/cbindgen;
    license = licenses.mpl20;
    maintainers = with maintainers; [ jtojnar andir ];
  };
}
