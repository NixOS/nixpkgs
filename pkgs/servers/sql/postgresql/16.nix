import ./generic.nix {
  version = "16.5";
  hash = "sha256-psu7cDf5jLivp9OXC3xIBAzwKxFeOSU6DAN6i7jnePA=";
  muslPatches = {
    dont-use-locale-a = {
      url = "https://git.alpinelinux.org/aports/plain/main/postgresql16/dont-use-locale-a-on-musl.patch?id=08a24be262339fd093e641860680944c3590238e";
      hash = "sha256-fk+y/SvyA4Tt8OIvDl7rje5dLs3Zw+Ln1oddyYzerOo=";
    };
  };
}
