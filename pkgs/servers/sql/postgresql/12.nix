import ./generic.nix {
  version = "12.21";
  hash = "sha256-bHEVUKwcx4KIZeWCPZ9Ffjva1vQyAXcWn5DkGb4MJ/I=";
  muslPatches = {
    dont-use-locale-a = {
      url = "https://git.alpinelinux.org/aports/plain/testing/postgresql12/dont-use-locale-a-on-musl.patch?id=d5227c91adda59d4e7f55f13468f0314e8869174";
      hash = "sha256-fk+y/SvyA4Tt8OIvDl7rje5dLs3Zw+Ln1oddyYzerOo=";
    };
  };
}
