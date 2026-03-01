{ callPackage, ccextractor }:

callPackage ./common.nix { } {
  pname = "tdarr-server";
  component = "server";

  hashes = {
    linux_x64 = "sha256-jNijxnglRqKYfgBWbNiB4oczDMYmLN2yyhJjZFflNUI=";
    linux_arm64 = "sha256-IlGlMD+NkpDbyh5G+XjnKcJuKLwFEvMq1bMAgnoOaRo=";
    darwin_x64 = "sha256-aRajMrdkqEtZeItRMMxiiLSrRGqHnKPo93/hsFd7sA8=";
    darwin_arm64 = "sha256-Bvbx/aOVTZJsgwLnIpabvcDJnu/XWilU/3bYzOIfZzQ=";
  };

  includeInPath = [ ccextractor ];
  installIcons = true;
}
