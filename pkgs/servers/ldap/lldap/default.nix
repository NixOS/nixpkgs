{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "lldap";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "nitnelave";
    repo = "lldap";
    rev = "v${version}";
    sha256 = "sha256-J1RFhve4j1IfZ0cEPBpD/rCw9jLNiS7nsvvOzi2ZQLg=";
  };

  # Cargo.lock is out of date
  cargoPatches = [ ./update-cargo-lock.patch ];

  cargoSha256 = "sha256-pO0kEVzgfOGn4PBzTrUyVfcelS+W6RfkYURTUXpms2k=";

  meta = with lib; {
    description = "Light LDAP implementation";
    longDescription = ''
       `lldap `is a lightweight authentication server that provides an
       opinionated, simplified LDAP interface for authentication.
    '';
    homepage = "https://github.com/nitnelave/lldap";
    license = licenses.gpl3;
    maintainers = with maintainers; [ deltadelta ];
  };
}
