import ./generic.nix {
  version = "15.10";
  rev = "ref/tags/REL_15_10";
  hash = "sha256-5RNcoqcmcYCCBK8bmz2Wruky1mzDh5SrDF3OOV31GMw=";
  muslPatches = {
    dont-use-locale-a = {
      url = "https://git.alpinelinux.org/aports/plain/main/postgresql15/dont-use-locale-a-on-musl.patch?id=f424e934e6d076c4ae065ce45e734aa283eecb9c";
      hash = "sha256-fk+y/SvyA4Tt8OIvDl7rje5dLs3Zw+Ln1oddyYzerOo=";
    };
  };
}
