{ stdenv
, lib
, fetchFromGitHub
, rustPlatform
, git
, nix-update-script
, pkg-config
, openssl
, dbus
, AppKit
, Security
}:

let
  pname = "ockam";
  version = "0.134.0";
in
rustPlatform.buildRustPackage {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "build-trust";
    repo = pname;
    rev = "ockam_v${version}";
    hash = "sha256-6HZI0Gsxn3GmklHl9zJ6yY73FlqcLiyMAqJg8BBmzqg=";
  };

  cargoHash = "sha256-VZt7tDewvz7eGpAKzD8pYOnH/3BtH6cULp6uX7CPxX8=";
  nativeBuildInputs = [ git pkg-config ];
  buildInputs = [ openssl dbus ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [ AppKit Security ];

  passthru.updateScript = nix-update-script { };

  # too many tests fail for now
  doCheck = false;

  meta = with lib; {
    description = "Orchestrate end-to-end encryption, cryptographic identities, mutual authentication, and authorization policies between distributed applications – at massive scale";
    homepage = "https://github.com/build-trust/ockam";
    license = licenses.mpl20;
    maintainers = with maintainers; [ happysalada ];
  };
}
