{ stdenv, rustPlatform, fetchFromGitHub
, libsodium, openssl
, pkgconfig
}:

with rustPlatform;

buildRustPackage rec {
  name = "tox-node-${version}";
  version = "0.0.7";

  src = fetchFromGitHub {
    owner = "tox-rs";
    repo = "tox-node";
    rev = "v${version}";
    sha256 = "0p1k4glqm3xasck66fywkyg42lbccad9rc6biyvi24rn76qip4jm";
  };

  buildInputs = [ libsodium openssl ];
  nativeBuildInputs = [ pkgconfig ];

  SODIUM_USE_PKG_CONFIG = "yes";

  installPhase = ''
    runHook preInstall

    install -D target/release/tox-node $out/bin/tox-node

    runHook postInstall
  '';

  doCheck = false;

  cargoSha256 = "18w1ycvj2q4q8lj81wn5lfljh5wa7b230ahqdz30w20pv1cazsv2";

  meta = with stdenv.lib; {
    description = "A server application to run tox node written in pure Rust";
    homepage = https://github.com/tox-rs/tox-node;
    license = [ licenses.mit ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ suhr ];
  };
}
