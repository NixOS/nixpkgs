# NOTE to maintainers: please check whether plugins include binaries or JARs in their distributions,
# as opposed to getting them from proper sources - accepting this is highly discouraged!
# The plugin building code will check for files with .jar extensions, but not more than that.
self: super: {
  ghidra-scala-loader = self.callPackage ./4_plugins/ghidra-scala-loader.nix { scala = self.pkgs.scala_2_11; };
    }
