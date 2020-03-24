{ stdenv, fetchFromGitHub, fetchpatch, rustPlatform, makeWrapper, Security }:

rustPlatform.buildRustPackage rec {
  pname = "racerd";
  version = "unstable-2019-09-02";

  src = fetchFromGitHub {
    owner = "jwilm";
    repo = "racerd";
    rev = "e3d380b9a1d3f3b67286d60465746bc89fea9098";
    sha256 = "13jqdvjk4savcl03mrn2vzgdsd7vxv2racqbyavrxp2cm9h6cjln";
  };

  cargoPatches = [
    (fetchpatch {
      url = "https://github.com/jwilm/racerd/commit/856f3656e160cd2909c5166e962f422c901720ee.patch";
      sha256 = "1qq2k4bnwjz5qgn7s8yxd090smwn2wvdm8dd1rrlgpln0a5vxkpb";
    })
  ];

  cargoSha256 = "1z0dh2j9ik66i6nww3z7z2gw7nhc0b061zxbjzamk1jybpc845lq";

  # a nightly compiler is required unless we use this cheat code.
  RUSTC_BOOTSTRAP=1;

  doCheck = false;

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
    homepage = "https://github.com/jwilm/racerd";
    license = licenses.asl20;
    platforms = platforms.all;
  };
}
