{ lib
, rustPlatform
, fetchFromGitLab
, pkg-config
, nettle
}:

rustPlatform.buildRustPackage rec {
  pname = "sequoia-chameleon-gnupg";
  version = "0.1.1";

  src = fetchFromGitLab {
    owner = "sequoia-pgp";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-liQNz833/3hi3eMi+/iEZ8fT9FFi+MrDIYbQD+dQ/p0=";
  };

  cargoHash = "sha256-bnScLSI94obYQH5YzoHY4DtGScKc4m24+SIg1d2kAKw=";

  nativeBuildInputs = [ rustPlatform.bindgenHook pkg-config ];
  buildInputs = [ nettle ];

  # gpgconf: error creating socket directory
  doCheck = false;

  meta = with lib; {
    description = "Sequoia's reimplementation of the GnuPG interface";
    homepage = "https://gitlab.com/sequoia-pgp/sequoia-chameleon-gnupg";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ nickcao ];
  };
}
