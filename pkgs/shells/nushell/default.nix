{ stdenv, fetchFromGitHub, rustPlatform, makeWrapper
, openssl
, pkg-config
}:

with rustPlatform;

buildRustPackage rec {
  pname = "nushell";
  version = "0.2.0";
  src = fetchFromGitHub {
    owner = "nushell";
    repo = "nushell";
    rev = version;
    sha256 = "0smk804g798pz6shpm78lg9zjsqjg4qj3hy8i4cmcj01q2mkmca6";
  };

  # a nightly compiler is required unless we use this cheat code.
  RUSTC_BOOTSTRAP=1;

  doCheck = false;

  cargoSha256 = "0k987jf9l4ln0b12m17lbxy2rnkzliahhhpqhh5wxphpn874zks5";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ makeWrapper openssl ];

  RUST_SRC_PATH = rustPlatform.rustcSrc;

  # installPhase = ''
  #   mkdir -p $out/bin
  #   cp -p target/release/racerd $out/bin/
  #   wrapProgram $out/bin/racerd --set-default RUST_SRC_PATH "$RUST_SRC_PATH"
  # '';

  meta = with stdenv.lib; {
    description = "toto";
    homepage = "https://github.com/nushell/nushell";
    license = licenses.asl20;
    platforms = platforms.all;
  };
}

