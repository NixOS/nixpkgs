{ stdenv, fetchFromGitHub, rustPlatform, makeWrapper , Security }:

with rustPlatform;

buildRustPackage rec {
  pname = "racerd";
  version = "2019-03-20";
  src = fetchFromGitHub {
    owner = "jwilm";
    repo = "racerd";
    rev = "6f74488e58e42314a36ff000bae796fe54c1bdd1";
    sha256 = "1lg7j2plxpn5l65jxhsm99vmy08ljdb666hm0y1nnmmzalrakrg1";
  };

  # a nightly compiler is required unless we use this cheat code.
  RUSTC_BOOTSTRAP=1;

  doCheck = false;

  cargoSha256 = "15894qr0kpp5kivx0p71zmmfhfh8in0ydkvfirxh2r12x0r2jhdd";

  buildInputs = [ makeWrapper ]
                ++ stdenv.lib.optional stdenv.isDarwin Security;

  RUST_SRC_PATH = rustPlatform.rustcSrc;

  installPhase = ''
    mkdir -p $out/bin
    cp -p target/release/racerd $out/bin/
    wrapProgram $out/bin/racerd --set-default RUST_SRC_PATH "$RUST_SRC_PATH"
  '';

  meta = with stdenv.lib; {
    description = "JSON/HTTP Server based on racer for adding Rust support to editors and IDEs";
    homepage = https://github.com/jwilm/racerd;
    license = licenses.asl20;
    platforms = platforms.all;
  };
}
