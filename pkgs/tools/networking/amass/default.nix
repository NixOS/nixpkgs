{ buildGoPackage
, fetchFromGitHub
, lib
}:

buildGoPackage rec {
  name = "amass-${version}";
  version = "2.8.3";

  goPackagePath = "github.com/OWASP/Amass";

  src = fetchFromGitHub {
    owner = "OWASP";
    repo = "Amass";
    rev = version;
    sha256 = "1pidi7bpg5z04l6ryfd7rqxshayvkqmgav0f6f1fxz4jwrmx9nnc";
  };

  # NOTE: this must be removed once amass > 2.8.3 is released. This version has
  # a broken import caused by the project migrating to a new home.
  preBuild = ''
    sed -e 's:github.com/caffix/amass/amass/core:github.com/OWASP/Amass/amass/core:g' -i "go/src/${goPackagePath}/cmd/amass.netdomains/main.go"
  '';

  goDeps = ./deps.nix;

  meta = with lib; {
    description = "In-Depth DNS Enumeration and Network Mapping";
    longDescription = ''
      The OWASP Amass tool suite obtains subdomain names by scraping data
      sources, recursive brute forcing, crawling web archives,
      permuting/altering names and reverse DNS sweeping. Additionally, Amass
      uses the IP addresses obtained during resolution to discover associated
      netblocks and ASNs. All the information is then used to build maps of the
      target networks.
      '';
    homepage = https://www.owasp.org/index.php/OWASP_Amass_Project;
    license = licenses.asl20;
    maintainers = with maintainers; [ kalbasit ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
