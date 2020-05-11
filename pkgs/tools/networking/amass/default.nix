{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "amass";
  version = "3.5.5";

  src = fetchFromGitHub {
    owner = "OWASP";
    repo = "Amass";
    rev = "v${version}";
    sha256 = "1w93ia9jr2afgkbaklx2rj0ccd0ghg1qbdg363aqqvyw40ccya1r";
  };

  modSha256 = "051fxfh7lwrj3hzsgr2c2ga6hksz56673lg35y36sz4d93yldj6f";

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
