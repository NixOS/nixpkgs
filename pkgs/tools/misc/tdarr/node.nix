{ callPackage, ccextractor }:

callPackage ./common.nix { } {
  pname = "tdarr-node";
  component = "node";

  hashes = {
    linux_x64 = "sha256-3dd8ouRfThm481rDJDnxxUuSkqNlFR+2aywPzyy7xrw=";
    linux_arm64 = "sha256-LD/cQECal9dLZY/FQSFztOVzd7MaeHL1rdbMUJ2DPNY=";
    darwin_x64 = "sha256-icgzoHqZ+P6gXJ8jQTau3O2D6uRvET4MtNoWJI/JnvM=";
    darwin_arm64 = "sha256-Rw478IpDLLe+Ek3Jt5Duaq1sHL1D3pE0HkVqk+v1ECE=";
  };

  includeInPath = [ ccextractor ];
}
