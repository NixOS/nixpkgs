<<<<<<< HEAD
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
  version = "2.0.1";
=======
{ lib, rustPlatform, fetchFromGitHub, pkg-config, udev, stdenv, Security }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-espflash";
  version = "1.7.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "esp-rs";
    repo = "espflash";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-PYW5OM3pbmROeGkbGiLhnVGrYq6xn3B1Z4sbIjtAPlk=";
=======
    sha256 = "sha256-AauIneSnacnY4mulD/qUgfN4K9tLzZXFug0oEsDuj18=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    pkg-config
  ];

<<<<<<< HEAD
  # Needed to get openssl-sys to use pkg-config.
  OPENSSL_NO_VENDOR = 1;

  buildInputs = [ openssl ] ++ lib.optionals stdenv.isLinux [
    udev
  ] ++ lib.optionals stdenv.isDarwin [
    Security
    SystemConfiguration
  ];

  cargoHash = "sha256-gTehRP9Ct150n3Kdz+NudJcKGeOCT059McrXURhy2iQ=";

  passthru.updateScript = nix-update-script { };
=======
  buildInputs = lib.optionals stdenv.isLinux [
    udev
  ] ++ lib.optionals stdenv.isDarwin [
    Security
  ];

  cargoSha256 = "sha256-82o3B6qmBVPpBVAogClmTbxrBRXY8Lmd2sHmonP5/s8=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Serial flasher utility for Espressif SoCs and modules based on esptool.py";
    homepage = "https://github.com/esp-rs/cargo-espflash";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ matthiasbeyer ];
  };
}
