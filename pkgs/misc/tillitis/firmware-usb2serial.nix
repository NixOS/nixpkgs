{ lib
, stdenv
, fetchFromGitHub
, callPackage
, sdcc
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tillitis-key1-firmware-usb2serial";
  inherit (finalAttrs.src.passthru) version;

  src = callPackage ./src.nix { };

  sourceRoot = "source/hw/boards/mta1-usb-v1/ch552_fw";

  hardeningDisable = [ "all" ];

  enableParallelBuilding = true;

  buildInputs = [
    sdcc
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp usb_device_cdc.{bin,hex} $out/
    runHook postInstall
  '';

  dontFixup = true;

  meta = import ./meta.nix { inherit lib; } // {
    description = "Tillitis Key1 USB-to-Serial Chip Firmware";
    longDescription = ''
      This builds the firmware which is flashed to the Tillitis
      Key1's on-board USB-to-Serial adapter chip.  You can use the
      nixpkgs `chprog` tool to write this firmware into the adapter
      chip's internal flash storage.
    '';
  };
})



