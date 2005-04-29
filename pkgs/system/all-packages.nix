# This file evaluates to a function that, when supplied with a system
# identifier, returns the set of all packages provided by the Nix
# Package Collection.  It does this by supplying
# `all-packages-generic.nix' with one of the standard build
# environments defined in `stdenvs.nix'.

{system ? __currentSystem}: let {
  allPackages = import ./all-packages-generic.nix;

  stdenvs = import ./stdenvs.nix {inherit system allPackages;};

  # Select the right instantiation.
  body =
    if system == "i686-linux" then stdenvs.stdenvLinuxPkgs
    else if system == "powerpc-darwin" then stdenvs.stdenvDarwinPkgs
    else stdenvs.stdenvNativePkgs;
}
