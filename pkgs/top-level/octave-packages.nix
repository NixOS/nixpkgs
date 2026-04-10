# This file contains the GNU Octave add-on packages set.
# Each attribute is an Octave library.
# Expressions for the Octave libraries are supposed to be in `pkgs/development/octave-modules/<name>/default.nix`.

# When contributing a new package, if that package has a dependency on another
# octave package, then you DO NOT need to explicitly list it as such when
# performing the callPackage. It will be passed implicitly.
# In addition, try to use the same dependencies as the ones octave needs, which
# should ensure greater compatibility between Octave itself and its packages.

# Like python-packages.nix, packages from top-level.nix are not in the scope
# of the `callPackage` used for packages here. So, when we do need packages
# from outside, we can `inherit` them from `pkgs`.
{
  pkgs,
  config,
  lib,
  stdenv,
  fetchurl,
  newScope,
  octave,
}:

let
  inherit (lib)
    catAttrs
    concatLists
    extends
    filter
    makeScope
    unique
    ;
  autoCalledPackages = import ./by-name-overlay.nix ../development/octave-modules/by-name;
in

makeScope newScope (
  extends autoCalledPackages (
    self:
    let
      callPackage = self.callPackage;

      buildOctavePackage = callPackage ../development/interpreters/octave/build-octave-package.nix {
        inherit lib stdenv;
        inherit octave;
        inherit computeRequiredOctavePackages;
      };

      # Given a list of required Octave package derivations, get a list of
      # ALL required Octave packages needed for the ones specified to run.
      computeRequiredOctavePackages =
        drvs:
        let
          # Check whether a derivation is an octave package
          hasOctavePackage = drv: drv ? isOctavePackage;
          packages = filter hasOctavePackage drvs;
        in
        unique (packages ++ concatLists (catAttrs "requiredOctavePackages" packages));

    in
    {

      inherit buildOctavePackage computeRequiredOctavePackages;

      inherit (callPackage ../development/interpreters/octave/hooks { })
        writeRequiredOctavePackagesHook
        ;

      gsl = callPackage ../development/octave-modules/gsl {
        inherit (pkgs) gsl;
      };

      netcdf = callPackage ../development/octave-modules/netcdf {
        inherit (pkgs) netcdf;
      };

      statistics = callPackage ../development/octave-modules/statistics { };

      strings = callPackage ../development/octave-modules/strings { };

      struct = callPackage ../development/octave-modules/struct { };

      symbolic = callPackage ../development/octave-modules/symbolic {
        inherit (octave) python;
      };

      tsa = callPackage ../development/octave-modules/tsa { };

      video = callPackage ../development/octave-modules/video { };

      windows = callPackage ../development/octave-modules/windows { };

      zeromq = callPackage ../development/octave-modules/zeromq {
        inherit (pkgs) zeromq autoreconfHook;
      };

    }
    // lib.optionalAttrs config.allowAliases {
      fem-fenics = throw "octavePackages.fem-fenics has been removed due to being broken for more than a year; see RFC 180"; # Added 2026-02-05
      level-set = throw "octavePackages.level-set has been removed due to being broken for more than a year; see RFC 180"; # Added 2026-02-05
      parallel = throw "octavePackages.parallel has been removed due to being broken for more than a year; see RFC 180"; # Added 2026-02-05
      sparsersb = throw "octavePackages.sparsersb has been removed due to being broken for more than a year; see RFC 180"; # Added 2026-02-05
      tisean = throw "octavePackages.tisean has been removed due to being broken for more than a year; see RFC 180"; # Added 2026-02-05
      vibes = throw "octavePackages.vibes has been removed due to being broken for more than a year; see RFC 180"; # Added 2026-02-05
      vrml = throw "octavePackages.vrml has been removed due to being broken for more than a year; see RFC 180"; # Added 2026-02-05
    }
  )
)
