self: super: {
  jdk = self.pkgs.jdk11;
  gradleGen = (self.pkgs.gradleGen.override {jdk = self.jdk;}).gradle_latest;

  ghidra = self.callPackage ../lib/ghidra.nix {};
  # For use with `eclipses.eclipseWithPlugins`, see tests/eclipse-00.nix
  ghidraDev = self.pkgs.eclipses.plugins.buildEclipseUpdateSite rec {
    name = "GhidraDev";
    version = self.config.ghidraDevVersion;

    sourceRoot = ".";

    src = self.ghidra + "/" + self.config.ghidraDevPath; 
    };
  }
