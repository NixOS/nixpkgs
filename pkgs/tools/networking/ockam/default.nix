{
  stdenv,
  lib,
  fetchFromGitHub,
  rustPlatform,
  git,
  nix-update-script,
  pkg-config,
  openssl,
  dbus,
  AppKit,
  Security,
}:

let
  pname = "ockam";
  version = "0.124.0";
in
rustPlatform.buildRustPackage {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "build-trust";
    repo = pname;
    rev = "ockam_v${version}";
    hash = "sha256-ovcZD9D/iVF3iIti+vQ29YIJE+UI64BeuA2huJsAx5s=";
  };

  cargoHash = "sha256-z+GIFN5Q3LWnT5PrZ291G2lHgd5mzDFkKwdcxUXvUnU=";
  nativeBuildInputs = [
    git
    pkg-config
  ];
  buildInputs =
    [
      openssl
      dbus
    ]
    ++ lib.optionals stdenv.isDarwin [
      AppKit
      Security
    ];

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
