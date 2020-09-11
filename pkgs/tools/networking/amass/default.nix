{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "amass";
  version = "3.10.1";

  src = fetchFromGitHub {
    owner = "OWASP";
    repo = "Amass";
    rev = "v${version}";
    sha256 = "1djkryx8bz2rg0iqqb30jb122ydiyli2i9xsvcdmd42c47hxg46y";
  };

  vendorSha256 = "0c3hyvy8s470zvrv49fx0iil59z0xq10dw4vnr55qgbm2k2pay6w";

  doCheck = false;

  outputs = [ "out" "wordlists" ];

  postInstall = ''
    mkdir -p $wordlists
    cp -R $src/examples/wordlists/*.txt $wordlists
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
    homepage = "https://www.owasp.org/index.php/OWASP_Amass_Project";
    license = licenses.asl20;
    maintainers = with maintainers; [ kalbasit ];
  };
}
