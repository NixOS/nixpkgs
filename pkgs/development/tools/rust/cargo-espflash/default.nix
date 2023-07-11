{
  lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, udev
, stdenv
, Security
, nix-update-script
, openssl
, SystemConfiguration
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-espflash";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "esp-rs";
    repo = "espflash";
    rev = "v${version}";
    hash = "sha256-3E0OC8DVP2muLyoN4DQfrdnK+idQEm7IpaA/CUIyYnU=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  # Needed to get openssl-sys to use pkg-config.
  OPENSSL_NO_VENDOR = 1;

  buildInputs = [ openssl ] ++ lib.optionals stdenv.isLinux [
    udev
  ] ++ lib.optionals stdenv.isDarwin [
    Security
    SystemConfiguration
  ];

  cargoHash = "sha256-8VIAmmtaQoIvD7wN+W3yUM0CEDadOQrv1wnJ4/AWKFA=";

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Serial flasher utility for Espressif SoCs and modules based on esptool.py";
    homepage = "https://github.com/esp-rs/cargo-espflash";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ matthiasbeyer ];
  };
}
