import ./generic.nix {
  version = "16.6";
  rev = "ref/tags/REL_16_6";
  hash = "sha256-cw/bSR9ZI6HFtbSTQxvuB7ng7V6g5SZZ7B0oMCz4E7Q=";
  muslPatches = {
    dont-use-locale-a = {
      url = "https://git.alpinelinux.org/aports/plain/main/postgresql16/dont-use-locale-a-on-musl.patch?id=08a24be262339fd093e641860680944c3590238e";
      hash = "sha256-fk+y/SvyA4Tt8OIvDl7rje5dLs3Zw+Ln1oddyYzerOo=";
    };
  };
}
