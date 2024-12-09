{ roundcubePlugin, fetchzip }:

roundcubePlugin rec {
  pname = "custom_from";
  version = "1.6.6";

  src = fetchzip {
    url = "https://github.com/r3c/custom_from/archive/refs/tags/${version}.zip";
    hash = "sha256-QvMYwFWY0BZOkzhDtW7XJ77i5mVkDNAiN4JBdsCuUy0=";
  };
}
