{ lib, rustPlatform, fetchFromGitHub
, libsodium, openssl
, pkg-config
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

  buildInputs = [ libsodium openssl ];
  nativeBuildInputs = [ pkg-config ];

  SODIUM_USE_PKG_CONFIG = "yes";

  doCheck = false;

  cargoSha256 = "sha256-J/0KO33vZmOvm6V7qCXInuAJTbRqyy5/qj6p6dEmoas=";

  meta = with lib; {
    description = "A server application to run tox node written in pure Rust";
    homepage = "https://github.com/tox-rs/tox-node";
    license = [ licenses.gpl3Plus ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ suhr ];
  };
}
