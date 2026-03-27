import ./generic.nix {
  version = "15.17";
  rev = "refs/tags/REL_15_17";
  hash = "sha256-IxvCNJfTbbKT/2dFnNLk3fNUYDaRwHQeeAmvGc1w/OY=";
  muslPatches = {
    dont-use-locale-a = {
      url = "https://git.alpinelinux.org/aports/plain/main/postgresql15/dont-use-locale-a-on-musl.patch?id=f424e934e6d076c4ae065ce45e734aa283eecb9c";
      hash = "sha256-fk+y/SvyA4Tt8OIvDl7rje5dLs3Zw+Ln1oddyYzerOo=";
    };
  };
}
