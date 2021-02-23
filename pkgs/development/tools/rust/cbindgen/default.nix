{ lib, stdenv, fetchFromGitHub, rustPlatform, Security }:

rustPlatform.buildRustPackage rec {
  pname = "rust-cbindgen";
  version = "0.17.0";

  src = fetchFromGitHub {
    owner = "eqrion";
    repo = "cbindgen";
    rev = "v${version}";
    sha256 = "1w9gf6fl1ncm2zlh0p29lislfsd35zd1mhns2mrxl2n734zavaqf";
  };

  cargoSha256 = "12jw1m842gzy0ma4drgmwk1jac663vysllfpl9cglr039j1sfsx2";

  buildInputs = lib.optional stdenv.isDarwin Security;

  doCheck = false;

  meta = with lib; {
    description = "A project for generating C bindings from Rust code";
    homepage = "https://github.com/eqrion/cbindgen";
    license = licenses.mpl20;
    maintainers = with maintainers; [ jtojnar ];
  };
}
