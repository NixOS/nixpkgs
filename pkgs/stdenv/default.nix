# This file chooses a sane default stdenv given the system, platform, etc.
#
# Rather than returning a stdenv, this returns a list of functions---one per
# each bootstrapping stage. See `./booter.nix` for exactly what this list should
# contain.

{
  # Args just for stdenvs' usage
  lib,
  # Args to pass on to the pkgset builder, too
  localSystem,
  crossSystem,
  config,
  overlays,
  crossOverlays ? [ ],
}@args:

let
  stagesFreeBSD = import ./freebsd args;

  # On Linux systems, the standard build environment consists of Nix-built
  # instances glibc and the `standard' Unix tools, i.e., the Posix utilities,
  # the GNU C compiler, and so on.
  stagesLinux = import ./linux args;

  stagesDarwin = import ./darwin args;

  stagesCross = import ./cross args;

  stagesCustom = import ./custom args;

in
# Select the appropriate stages for the platform `system'.
if crossSystem != localSystem || crossOverlays != [ ] then
  stagesCross
else if config ? replaceStdenv then
  stagesCustom
else if localSystem.isLinux then
  stagesLinux
else if localSystem.isDarwin then
  stagesDarwin
# misc special cases
else
  {
    x86_64-freebsd = stagesFreeBSD;
  }
  .${localSystem.system}
