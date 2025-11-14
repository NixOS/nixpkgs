import ./generic.nix {
  version = "16.11";
  # TODO: Move back to tag, when they appear upstream:
  # rev = "refs/tags/REL_16_11";
  rev = "d61dd817be70749d14e982a369e97fdda9d5cba6";
  hash = "sha256-hxv+N+OWqiXmFmsB+SSYGKQLBbHtNMnneHFvOtUz8z4=";
  muslPatches = {
    dont-use-locale-a = {
      url = "https://git.alpinelinux.org/aports/plain/main/postgresql16/dont-use-locale-a-on-musl.patch?id=08a24be262339fd093e641860680944c3590238e";
      hash = "sha256-fk+y/SvyA4Tt8OIvDl7rje5dLs3Zw+Ln1oddyYzerOo=";
    };
  };
}
