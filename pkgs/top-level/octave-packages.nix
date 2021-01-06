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
{ pkgs
, lib
, stdenv
, fetchurl
, newScope
, octave
}:

with lib;

makeScope newScope (self:
  let
    inherit (octave) blas lapack gfortran python texinfo gnuplot;

    callPackage = self.callPackage;

    buildOctavePackage = callPackage ../development/interpreters/octave/build-octave-package.nix {
      inherit lib stdenv;
      inherit octave;
      inherit computeRequiredOctavePackages;
    };

    wrapOctave = callPackage ../development/interpreters/octave/wrap-octave.nix {
      inherit octave;
      inherit (pkgs) makeSetupHook makeWrapper;
    };

    # Given a list of required Octave package derivations, get a list of
    # ALL required Octave packages needed for the ones specified to run.
    computeRequiredOctavePackages = drvs: let
      # Check whether a derivation is an octave package
      hasOctavePackage = drv: drv?isOctavePackage;
      packages = filter hasOctavePackage drvs;
    in unique (packages ++ concatLists (catAttrs "requiredOctavePackages" packages));

  in {

    inherit callPackage buildOctavePackage computeRequiredOctavePackages;

    inherit (callPackage ../development/interpreters/octave/hooks { })
      writeRequiredOctavePackagesHook;

    arduino = callPackage ../development/octave-modules/arduino {
      inherit (pkgs) arduino;
    };

    audio = callPackage ../development/octave-modules/audio { };

    bim = callPackage ../development/octave-modules/bim { };

    bsltl = callPackage ../development/octave-modules/bsltl { };

    cgi = callPackage ../development/octave-modules/cgi { };

    communications = callPackage ../development/octave-modules/communications { };

    control = callPackage ../development/octave-modules/control { };

    data-smoothing = callPackage ../development/octave-modules/data-smoothing { };

    database = callPackage ../development/octave-modules/database { };

    dataframe = callPackage ../development/octave-modules/dataframe { };

    dicom = callPackage ../development/octave-modules/dicom { };

    divand = callPackage ../development/octave-modules/divand { };

    doctest = callPackage ../development/octave-modules/doctest { };

    general = callPackage ../development/octave-modules/general {
      nettle = pkgs.nettle;
    };

    io = callPackage ../development/octave-modules/io {
      inherit (octave) enableJava;
    };

    level-set = callPackage ../development/octave-modules/level-set { };

    linear-algebra = callPackage ../development/octave-modules/linear-algebra { };

    ltfat = callPackage ../development/octave-modules/ltfat {
      inherit (octave) fftw fftwSinglePrec portaudio jdk;
      inherit (pkgs) fftwFloat fftwLongDouble;
    };

    signal = callPackage ../development/octave-modules/signal { };

    symbolic = callPackage ../development/octave-modules/symbolic {
      inherit (octave) python;
    };

  })
