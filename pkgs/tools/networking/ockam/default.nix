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
  version = "0.138.0";
in
rustPlatform.buildRustPackage {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "build-trust";
    repo = pname;
    rev = "ockam_v${version}";
    hash = "sha256-AY0i7qXA7JXfIEY0htmL+/yn71xAuh7WowXOs2fD6n8=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-Mt/UFVFLZRrY8Mka4VFi6J2XjBjFsnJPi9tnBVZ6a5E=";
  nativeBuildInputs = [
    git
    pkg-config
  ];
  buildInputs =
    [
      openssl
      dbus
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
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
