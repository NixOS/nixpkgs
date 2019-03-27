ghidraDevZip: {eclipses, fetchzip}:
  eclipses.plugins.buildEclipseUpdateSite rec {
    name = "GhidraDev";
    version = "2.0.0";

    sourceRoot = ".";

    src = ghidraDevZip;
    }
