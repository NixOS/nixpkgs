{ lib
, stdenv
, pkg-config
, fetchFromGitHub
, libusb1
}:

# IMPORTANT: You need permissions to access the stlink usb devices.
# Add services.udev.packages = [ pkgs.stlink ] to your configuration.nix
stdenv.mkDerivation rec {
  pname = "stlink-tool";
  version = "unstable-2023-10-20";

  src = fetchFromGitHub {
    owner = "UweBonnes";
    repo = pname;
    rev = "3ab0b140561c18c6e51183877c849b7b8ca0319c";
    sha256 = "sha256-Wj72kHckxnox0kfqEZzE5zeSi8Bc+QSHPs4BtIf6RhE=";
    fetchSubmodules = true;
  };

  buildInputs = [ libusb1 ];
  nativeBuildInputs = [ pkg-config ];

  preBuild = ''
    NIX_CFLAGS_COMPILE="-Wno-uninitialized $NIX_CFLAGS_COMPILE"
  '';

  installPhase = ''
    runHook preInstall
    install -D stlink-tool $out/bin/stlink-tool
    runHook postInstall
  '';

  meta = with lib;
    {
      description = "libusb tool for flashing chinese ST-Link dongles";
      license = licenses.mit;
      platforms = platforms.unix;
      maintainers = [ maintainers.wucke13 ];
    };
}
