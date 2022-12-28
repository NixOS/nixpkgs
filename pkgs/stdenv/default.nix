# This file chooses a sane default stdenv given the system, platform, etc.
#
# Rather than returning a stdenv, this returns a list of functions---one per
# each bootstrapping stage. See `./booter.nix` for exactly what this list should
# contain.

{ # Args just for stdenvs' usage
  lib
  # Args to pass on to the pkgset builder, too
, localSystem, crossSystem, config, overlays, crossOverlays ? []
} @ args:

let
  # The native (i.e., impure) build environment.  This one uses the
  # tools installed on the system outside of the Nix environment,
  # i.e., the stuff in /bin, /usr/bin, etc.  This environment should
  # be used with care, since many Nix packages will not build properly
  # with it (e.g., because they require GNU Make).
  stagesNative = import ./native args;

  # The Nix build environment.
  stagesNix = import ./nix (args // { bootStages = stagesNative; });

  stagesFreeBSD = import ./freebsd args;

  # On Linux systems, the standard build environment consists of Nix-built
  # instances glibc and the `standard' Unix tools, i.e., the Posix utilities,
  # the GNU C compiler, and so on.
  stagesLinux = import ./linux args;

  inherit (import ./darwin args) stagesDarwin;

  stagesCross = import ./cross args;

  stagesCustom = import ./custom args;

  # Select the appropriate stages for the platform `system'.
in
  if crossSystem != localSystem || crossOverlays != [] then stagesCross
  else if config ? replaceStdenv then stagesCustom
  else if localSystem.isLinux then stagesLinux
  else if localSystem.isDarwin then stagesDarwin
  else # misc special cases
  { # switch
    x86_64-solaris = stagesNix;
    i686-cygwin = stagesNative;
    x86_64-cygwin = stagesNative;
    x86_64-freebsd = stagesFreeBSD;
  }.${localSystem.system} or stagesNative
