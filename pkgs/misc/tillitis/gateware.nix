{ lib
, stdenv
, fetchFromGitHub
, callPackage

# Gateware compilation/synthesis tools
, yosys
, nextpnr
, icestorm  # for icebram
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tillitis-key1-gateware";
  inherit (finalAttrs.src.passthru) version;

  src = callPackage ./src.nix { };

  sourceRoot = "source/hw/application_fpga";

  nativeBuildInputs = [
    yosys
  ];

  buildInputs = [
    nextpnr
    icestorm
  ];

  enableParallelBuilding = true;

  # TODO: udev rules for `1207:8887 Tillitis MTA1-USB-V1`
  # `make secret` runs `../tools/tpt/tpt.py` -- this generates your unique device secret
  # `make prog_flash` runs `tillitis-iceprog application_fpga.bin`

  makeFlags = [
    #"application_fpga.bin" # combined firmware+gateware
    "application_fpga.asc" # gateware
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp application_fpga.asc $out/
    runHook postInstall
  '';

  dontFixup = true;

  meta = import ./meta.nix { inherit lib; } // {
    description = "Tillitis Key1 FPGA Gateware";
  };
})


