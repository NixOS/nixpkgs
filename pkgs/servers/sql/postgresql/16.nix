import ./generic.nix {
  version = "16.9";
  rev = "refs/tags/REL_16_9";
  hash = "sha256-CLLCT4wiCWeLqMdtGdXM2/DtlENLWSey6nNtOcfNPRw=";
  muslPatches = {
    dont-use-locale-a = {
      url = "https://git.alpinelinux.org/aports/plain/main/postgresql16/dont-use-locale-a-on-musl.patch?id=08a24be262339fd093e641860680944c3590238e";
      hash = "sha256-fk+y/SvyA4Tt8OIvDl7rje5dLs3Zw+Ln1oddyYzerOo=";
    };
  };
}
