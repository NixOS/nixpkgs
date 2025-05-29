{
  lib,
  stdenv,
  newScope,
  gnuradio, # unwrapped gnuradio
}:

lib.makeScope newScope (
  self:

  let
    # Modeled after qt's
    mkDerivationWith = import ../development/gnuradio-modules/mkDerivation.nix {
      inherit lib;
      unwrapped = gnuradio;
    };
    mkDerivation = mkDerivationWith stdenv.mkDerivation;

    callPackage = self.newScope (
      {
        inherit (gnuradio)
          # Packages that are potentially overridden and used as deps here.
          boost
          volk
          logLib
          python
          qwt
          ;
        inherit mkDerivationWith mkDerivation;
        inherit gnuradio;
        inherit (gnuradio) gnuradioOlder gnuradioAtLeast;
      }
      // lib.optionalAttrs (gnuradio.hasFeature "gr-uhd") {
        inherit (gnuradio) uhd;
      }
    );
  in
  {

    inherit callPackage mkDerivation mkDerivationWith;

    ### Packages

    bladeRF = callPackage ../development/gnuradio-modules/bladeRF/default.nix { };

    lora_sdr = callPackage ../development/gnuradio-modules/lora_sdr/default.nix { };

    osmosdr = callPackage ../development/gnuradio-modules/osmosdr/default.nix { };

    fosphor = callPackage ../development/gnuradio-modules/fosphor/default.nix { };

  }
)
