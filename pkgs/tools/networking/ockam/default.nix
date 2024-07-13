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
  version = "0.129.0";
in
rustPlatform.buildRustPackage {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "build-trust";
    repo = pname;
    rev = "ockam_v${version}";
    hash = "sha256-KlfR5/SYm8r5c31P0L8HF/mBAkwPesZedKNR0hKxAR0=";
  };

  cargoHash = "sha256-YadksBZIwUfJN1pPpDDwQNknOyzc6WRTZZlOUZxI5uk=";
  nativeBuildInputs = [ git pkg-config ];
  buildInputs = [ openssl dbus ]
    ++ lib.optionals stdenv.isDarwin [ AppKit Security ];

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
