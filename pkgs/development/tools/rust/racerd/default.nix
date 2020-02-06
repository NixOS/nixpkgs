{ stdenv, fetchFromGitHub, rustPlatform, makeWrapper , Security }:

with rustPlatform;

buildRustPackage rec {
  pname = "racerd";
  version = "unstable-2019-09-02";
  src = fetchFromGitHub {
    owner = "jwilm";
    repo = "racerd";
    rev = "e3d380b9a1d3f3b67286d60465746bc89fea9098";
    sha256 = "13jqdvjk4savcl03mrn2vzgdsd7vxv2racqbyavrxp2cm9h6cjln";
  };

  # a nightly compiler is required unless we use this cheat code.
  RUSTC_BOOTSTRAP=1;

  doCheck = false;

  cargoSha256 = "07130587drrdkrk7aqb8pl8i3p485qr6xh1m86630ydlnb9z6s6i";

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = stdenv.lib.optional stdenv.isDarwin Security;

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
