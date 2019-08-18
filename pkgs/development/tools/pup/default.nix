{ lib, buildGoPackage, fetchgit }:

buildGoPackage rec {
  pname = "pup";
  version = "0.4.0";
  rev = "v${version}";

  goPackagePath = "github.com/ericchiang/pup";

  src = fetchgit {
    inherit rev;
    url = "https://${goPackagePath}";
    sha256 = "0mnhw0yph5fvcnrcmj1kfbyw1a4lcg3k9f6y28kf44ihlq8h1dfz";
  };

  meta = with lib; {
    description = "Streaming HTML processor/selector";
    license = licenses.mit;
    maintainers = with maintainers; [ yegortimoshenko ];
  };
}
