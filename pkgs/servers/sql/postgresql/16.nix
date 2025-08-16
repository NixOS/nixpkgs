import ./generic.nix {
  version = "16.10";
  rev = "refs/tags/REL_16_10";
  hash = "sha256-1zG8+G/lNA1xm0hxLVEilIaI+25d4gfpqA2aCb4+taY=";
  muslPatches = {
    dont-use-locale-a = {
      url = "https://git.alpinelinux.org/aports/plain/main/postgresql16/dont-use-locale-a-on-musl.patch?id=08a24be262339fd093e641860680944c3590238e";
      hash = "sha256-fk+y/SvyA4Tt8OIvDl7rje5dLs3Zw+Ln1oddyYzerOo=";
    };
  };
}
