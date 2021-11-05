{ lib, rustPlatform, fetchFromGitHub
, libsodium, openssl
, pkg-config
, fetchpatch
}:

with rustPlatform;

buildRustPackage rec {
  pname = "tox-node";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "tox-rs";
    repo = "tox-node";
    rev = "v${version}";
    sha256 = "sha256-tB6v2NEBdTNHf89USdQOr/pV0mbxxb8ftOYPPJMvz5Y=";
  };

  cargoPatches = [
    # update cargo lock
    (fetchpatch {
      url = "https://github.com/tox-rs/tox-node/commit/63712d49d84e55df7bba9710e129780bbc636de3.patch";
      sha256 = "sha256-jI6b5IHsAuGuM+7sPCdFnOOuV6K9rBmc5QqU5x72Fl0=";
    })
  ];

  buildInputs = [ libsodium openssl ];
  nativeBuildInputs = [ pkg-config ];

  SODIUM_USE_PKG_CONFIG = "yes";

  doCheck = false;

  cargoSha256 = "sha256-yHsYjKJJNjepvcNszj4XQ0DbOY3AEJMZOnz0cAiwO1A=";

  meta = with lib; {
    description = "A server application to run tox node written in pure Rust";
    homepage = "https://github.com/tox-rs/tox-node";
    license = [ licenses.gpl3Plus ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ suhr kurnevsky ];
  };
}
