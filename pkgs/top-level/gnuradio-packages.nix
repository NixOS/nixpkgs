{ lib
, stdenv
, newScope
, gnuradio # unwrapped gnuradio
}:

lib.makeScope newScope ( self:

let
  # Modeled after qt's
  mkDerivationWith = import ../development/gnuradio-modules/mkDerivation.nix {
    inherit lib;
    unwrapped = gnuradio;
  };
  mkDerivation = mkDerivationWith stdenv.mkDerivation;

  callPackage = self.newScope ({
    inherit (gnuradio)
      # Packages that are potentially overriden and used as deps here.
      boost
      volk
    ;
    inherit mkDerivationWith mkDerivation;
  } // lib.optionalAttrs (gnuradio.hasFeature "gr-uhd") {
    inherit (gnuradio) uhd;
  } // (if (lib.versionAtLeast gnuradio.versionAttr.major "3.10") then {
    inherit (gnuradio) spdlog;
  } else {
    inherit (gnuradio) log4cpp;
  }));
in {

  inherit callPackage mkDerivation mkDerivationWith;

  ### Packages

  inherit gnuradio;
  inherit (gnuradio) python;

  osmosdr = callPackage ../development/gnuradio-modules/osmosdr/default.nix { };

  ais = callPackage ../development/gnuradio-modules/ais/default.nix { };

  grnet = callPackage ../development/gnuradio-modules/grnet/default.nix { };

  gsm = callPackage ../development/gnuradio-modules/gsm/default.nix { };

  nacl = callPackage ../development/gnuradio-modules/nacl/default.nix { };

  rds = callPackage ../development/gnuradio-modules/rds/default.nix { };

  limesdr = callPackage ../development/gnuradio-modules/limesdr/default.nix { };

})
