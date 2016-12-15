# This file mimicks top-level/default.nix, and is used to provide default
# arguments for testing stdenvs.

let lib = import ../../lib; in

builtins.trace

"Information from pkgs/stdenv/debug.nix is strictly for debugging. You should not see this message durring normal use of nixpkgs."

(lib.makeExtensible (self: {
  test-pkgspath = ../..;

  lib = import (self.test-pkgspath + "/lib");
  platforms = import (self.test-pkgspath + "/pkgs/top-level/platforms.nix");
  allPackages = args: import (self.test-pkgspath + "/pkgs/top-level/stage.nix") ({
    inherit (self) lib;
    nixpkgsFun = args: builtins.abort
      "`nixpkgsFun` is too difficult to support for this mockup, and shouldn't be used by packages anyways.";
  } // args);

  system = builtins.currentSystem;
  platform = self.platforms.selectPlatformBySystem self.system;
  crossSystem = null;
  config = {};
}))
