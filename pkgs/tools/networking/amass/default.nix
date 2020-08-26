{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "amass";
  version = "3.8.2";

  src = fetchFromGitHub {
    owner = "OWASP";
    repo = "Amass";
    rev = "v${version}";
    sha256 = "0hm5h8glva0d9mj870j56bc721w4br7dzwhns096rgzyv93m7rx0";
  };

  vendorSha256 = "1g3jbdx7m5m56ifcc1p6hgz2wzmb287cyyaiz03ffdvwd3k73k4j";

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
