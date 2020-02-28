{ stdenv, rustPlatform, fetchFromGitHub
, libsodium, openssl
, pkgconfig
}:

with rustPlatform;

buildRustPackage rec {
  pname = "tox-node";
  version = "0.0.8";

  src = fetchFromGitHub {
    owner = "tox-rs";
    repo = "tox-node";
    rev = "v${version}";
    sha256 = "0vnjbhz74d4s6701xsd46ygx0kq8wd8xwpajvkhdivc042mw9078";
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

  cargoSha256 = "1ka22krw8s05vpamg9naqqf7vv5h8dkpfdik0wy8nispkrxzgb92";

  meta = with stdenv.lib; {
    description = "A server application to run tox node written in pure Rust";
    homepage = https://github.com/tox-rs/tox-node;
    license = [ licenses.mit ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ suhr ];
  };
}
