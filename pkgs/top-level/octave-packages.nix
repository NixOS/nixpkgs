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
    filter
    makeScope
    unique
    ;
in

makeScope newScope (
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

    inherit callPackage buildOctavePackage computeRequiredOctavePackages;

    inherit (callPackage ../development/interpreters/octave/hooks { })
      writeRequiredOctavePackagesHook
      ;

    arduino = callPackage ../development/octave-modules/arduino {
      inherit (pkgs) arduino-core-unwrapped;
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

    econometrics = callPackage ../development/octave-modules/econometrics { };

    fem-fenics = callPackage ../development/octave-modules/fem-fenics {
      # PLACEHOLDER until KarlJoad gets dolfin packaged.
      dolfin = null;
      ffc = null;
    };

    fits = callPackage ../development/octave-modules/fits { };

    financial = callPackage ../development/octave-modules/financial { };

    fpl = callPackage ../development/octave-modules/fpl { };

    fuzzy-logic-toolkit = callPackage ../development/octave-modules/fuzzy-logic-toolkit { };

    ga = callPackage ../development/octave-modules/ga { };

    general = callPackage ../development/octave-modules/general {
      nettle = pkgs.nettle;
    };

    generate_html = callPackage ../development/octave-modules/generate_html { };

    geometry = callPackage ../development/octave-modules/geometry { };

    gsl = callPackage ../development/octave-modules/gsl {
      inherit (pkgs) gsl;
    };

    image = callPackage ../development/octave-modules/image { };

    image-acquisition = callPackage ../development/octave-modules/image-acquisition { };

    instrument-control = callPackage ../development/octave-modules/instrument-control { };

    io = callPackage ../development/octave-modules/io {
      inherit (octave) enableJava;
    };

    interval = callPackage ../development/octave-modules/interval { };

    level-set = callPackage ../development/octave-modules/level-set { };

    linear-algebra = callPackage ../development/octave-modules/linear-algebra { };

    lssa = callPackage ../development/octave-modules/lssa { };

    ltfat = callPackage ../development/octave-modules/ltfat {
      inherit (octave)
        fftw
        fftwSinglePrec
        portaudio
        jdk
        ;
      inherit (pkgs) fftwFloat fftwLongDouble;
    };

    mapping = callPackage ../development/octave-modules/mapping { };

    matgeom = callPackage ../development/octave-modules/matgeom { };

    miscellaneous = callPackage ../development/octave-modules/miscellaneous { };

    msh = callPackage ../development/octave-modules/msh {
      # PLACEHOLDER until KarlJoad gets dolfin packaged.
      dolfin = null;
    };

    mvn = callPackage ../development/octave-modules/mvn { };

    nan = callPackage ../development/octave-modules/nan { };

    ncarray = callPackage ../development/octave-modules/ncarray { };

    netcdf = callPackage ../development/octave-modules/netcdf {
      inherit (pkgs) netcdf;
    };

    nurbs = callPackage ../development/octave-modules/nurbs { };

    ocl = callPackage ../development/octave-modules/ocl { };

    octclip = callPackage ../development/octave-modules/octclip { };

    octproj = callPackage ../development/octave-modules/octproj { };

    optics = callPackage ../development/octave-modules/optics { };

    optim = callPackage ../development/octave-modules/optim { };

    optiminterp = callPackage ../development/octave-modules/optiminterp { };

    parallel = callPackage ../development/octave-modules/parallel { };

    quaternion = callPackage ../development/octave-modules/quaternion { };

    queueing = callPackage ../development/octave-modules/queueing { };

    signal = callPackage ../development/octave-modules/signal { };

    sockets = callPackage ../development/octave-modules/sockets { };

    sparsersb = callPackage ../development/octave-modules/sparsersb { };

    stk = callPackage ../development/octave-modules/stk { };

    splines = callPackage ../development/octave-modules/splines { };

    statistics = callPackage ../development/octave-modules/statistics { };

    strings = callPackage ../development/octave-modules/strings { };

    struct = callPackage ../development/octave-modules/struct { };

    symbolic = callPackage ../development/octave-modules/symbolic {
      inherit (octave) python;
    };

    tisean = callPackage ../development/octave-modules/tisean { };

    tsa = callPackage ../development/octave-modules/tsa { };

    vibes = callPackage ../development/octave-modules/vibes {
      vibes = null;
      # TODO: Need to package vibes:
      # https://github.com/ENSTABretagneRobotics/VIBES
    };

    video = callPackage ../development/octave-modules/video { };

    vrml = callPackage ../development/octave-modules/vrml {
      freewrl = null;
    };

    windows = callPackage ../development/octave-modules/windows { };

    zeromq = callPackage ../development/octave-modules/zeromq {
      inherit (pkgs) zeromq autoreconfHook;
    };

  }
)
