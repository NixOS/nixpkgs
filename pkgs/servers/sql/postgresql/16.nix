import ./generic.nix {
  version = "16.2";
  hash = "sha256-RG6IKU28LJCFq0twYaZG+mBLS+wDUh1epnHC5a2bKVI=";
  muslPatches = {
    icu-collations-hack = {
      url = "https://git.alpinelinux.org/aports/plain/main/postgresql16/icu-collations-hack.patch?id=08a24be262339fd093e641860680944c3590238e";
      hash = "sha256-+urQdVIlADLdDPeT68XYv5rljhbK8M/7mPZn/cF+FT0=";
    };
  };
}
