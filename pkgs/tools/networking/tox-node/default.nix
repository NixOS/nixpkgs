{ stdenv, rustPlatform, fetchFromGitHub
, libsodium, openssl
, pkgconfig
}:

with rustPlatform;

buildRustPackage rec {
  pname = "tox-node";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "tox-rs";
    repo = "tox-node";
    rev = "v${version}";
    sha256 = "0bar42nigjwn7dq48rmg74sm3gnfqvb6gnd9g1n0i8nmynd00wvn";
  };

  buildInputs = [ libsodium openssl ];
  nativeBuildInputs = [ pkgconfig ];

  SODIUM_USE_PKG_CONFIG = "yes";

  installPhase = ''
    runHook preInstall

    install -D $releaseDir/tox-node $out/bin/tox-node

    runHook postInstall
  '';

  doCheck = false;

  cargoSha256 = "087ccb824hmmxmnn5c2bzww2q888a8zy6y7rwgsdfr8rbay2c909";

  meta = with stdenv.lib; {
    description = "A server application to run tox node written in pure Rust";
    homepage = "https://github.com/tox-rs/tox-node";
    license = [ licenses.gpl3Plus ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ suhr ];
  };
}
