import ./generic.nix {
  version = "15.13";
  rev = "refs/tags/REL_15_13";
  hash = "sha256-6guX2ms54HhJJ0MoHfQb5MI9qrcA0niJ06oa1glsFuY=";
  muslPatches = {
    dont-use-locale-a = {
      url = "https://git.alpinelinux.org/aports/plain/main/postgresql15/dont-use-locale-a-on-musl.patch?id=f424e934e6d076c4ae065ce45e734aa283eecb9c";
      hash = "sha256-fk+y/SvyA4Tt8OIvDl7rje5dLs3Zw+Ln1oddyYzerOo=";
    };
  };
}
