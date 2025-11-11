import ./generic.nix {
  version = "15.15";
  # TODO: Move back to tag, when they appear upstream:
  # rev = "refs/tags/REL_15_15";
  rev = "32f38816779420502d4a311835d5fe939e9548a0";
  hash = "sha256-veGKXAvK+dNofBuSXsmCsPdXDJOC04+QV3HEr0XaE68=";
  muslPatches = {
    dont-use-locale-a = {
      url = "https://git.alpinelinux.org/aports/plain/main/postgresql15/dont-use-locale-a-on-musl.patch?id=f424e934e6d076c4ae065ce45e734aa283eecb9c";
      hash = "sha256-fk+y/SvyA4Tt8OIvDl7rje5dLs3Zw+Ln1oddyYzerOo=";
    };
  };
}
