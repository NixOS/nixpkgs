import ./generic.nix {
  version = "16.13";
  rev = "refs/tags/REL_16_13";
  hash = "sha256-Ue117xTq4RMQfq70mnXRBwqJ+IUigW27FvHY7I519ng=";
  muslPatches = {
    dont-use-locale-a = {
      url = "https://git.alpinelinux.org/aports/plain/main/postgresql16/dont-use-locale-a-on-musl.patch?id=08a24be262339fd093e641860680944c3590238e";
      hash = "sha256-fk+y/SvyA4Tt8OIvDl7rje5dLs3Zw+Ln1oddyYzerOo=";
    };
  };
}
