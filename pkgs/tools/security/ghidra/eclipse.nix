ghidraDevZip: {eclipses, fetchzip}:
  eclipses.plugins.buildEclipseUpdateSite rec {
    name = "GhidraDev";
    version = "2.0.0";

    sourceRoot = "."; #TODO I dont think this is correct but it works?

    src = ghidraDevZip;
    }
