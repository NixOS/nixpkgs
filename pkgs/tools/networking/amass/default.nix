{ buildGoPackage
, fetchFromGitHub
, fetchpatch
, lib
}:

buildGoPackage rec {
  name = "amass-${version}";
  version = "2.8.5";

  goPackagePath = "github.com/OWASP/Amass";

  src = fetchFromGitHub {
    owner = "OWASP";
    repo = "Amass";
    rev = version;
    sha256 = "1nsqg1p7hcv369d53n13xps3ks6fgzkkp6v9q87l04yj32nbr5qy";
  };

  outputs = [ "bin" "out" "wordlists" ];

  goDeps = ./deps.nix;

  postInstall = ''
    mkdir -p $wordlists
    cp -R $src/wordlists/*.txt $wordlists
    gzip $wordlists/*.txt
  '';

  meta = with lib; {
    description = "In-Depth DNS Enumeration and Network Mapping";
    longDescription = ''
      The OWASP Amass tool suite obtains subdomain names by scraping data
      sources, recursive brute forcing, crawling web archives,
      permuting/altering names and reverse DNS sweeping. Additionally, Amass
      uses the IP addresses obtained during resolution to discover associated
      netblocks and ASNs. All the information is then used to build maps of the
      target networks.

      Amass ships with a set of wordlist (to be used with the amass -w flag)
      that are found under the wordlists output.
      '';
    homepage = https://www.owasp.org/index.php/OWASP_Amass_Project;
    license = licenses.asl20;
    maintainers = with maintainers; [ kalbasit ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
