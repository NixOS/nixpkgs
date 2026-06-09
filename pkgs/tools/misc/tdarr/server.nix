{ callPackage, ccextractor }:

callPackage ./common.nix { } {
  pname = "tdarr-server";
  component = "server";

  hashes = {
    linux_x64 = "sha256-4G1wHHWmSsFveSWcooW/QN6YHgUnqID1D7z1G3xKYTk=";
    linux_arm64 = "sha256-Sx06jR8kKQOwTmaaNCyiX0KyUtgXNrQJkMsZjAGhlAQ=";
    darwin_x64 = "sha256-4W1q7YaLMOIyiuyZ1oIVGb1Fz2qwFHrgMb78Q7lmpbI=";
    darwin_arm64 = "sha256-ziuaZZi1QZ10d+6lWdOzPFTbCe75bKDHPxxDdI1wsj8=";
  };

  includeInPath = [ ccextractor ];
  installIcons = true;
}
