{ buildGoPackage, fetchgit }:

buildGoPackage rec {
  name = "pup-${version}";
  version = "0.4.0";
  rev = "v${version}";

  goPackagePath = "github.com/ericchiang/pup";

  src = fetchgit {
    inherit rev;
    url = "https://${goPackagePath}";
    sha256 = "0mnhw0yph5fvcnrcmj1kfbyw1a4lcg3k9f6y28kf44ihlq8h1dfz";
  };
}
