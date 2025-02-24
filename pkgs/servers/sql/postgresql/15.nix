import ./generic.nix {
  version = "15.12";
  rev = "refs/tags/REL_15_12";
  hash = "sha256-6my9UzW05iYwTWR9y/VTZ1RQVNudavMFfUT9dpUQ15o=";
  muslPatches = {
    dont-use-locale-a = {
      url = "https://git.alpinelinux.org/aports/plain/main/postgresql15/dont-use-locale-a-on-musl.patch?id=f424e934e6d076c4ae065ce45e734aa283eecb9c";
      hash = "sha256-fk+y/SvyA4Tt8OIvDl7rje5dLs3Zw+Ln1oddyYzerOo=";
    };
  };
}
