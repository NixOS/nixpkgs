import ./generic.nix {
  version = "12.20";
  hash = "sha256-LVQ68wCf7H/VrzX3pwyVCF0+72tQjlF6qUk+mbFenqk=";
  muslPatches = {
    dont-use-locale-a = {
      url = "https://git.alpinelinux.org/aports/plain/testing/postgresql12/dont-use-locale-a-on-musl.patch?id=d5227c91adda59d4e7f55f13468f0314e8869174";
      hash = "sha256-fk+y/SvyA4Tt8OIvDl7rje5dLs3Zw+Ln1oddyYzerOo=";
    };
  };
}
