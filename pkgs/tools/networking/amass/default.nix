{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "amass";
  version = "3.17.1";

  src = fetchFromGitHub {
    owner = "OWASP";
    repo = "Amass";
    rev = "v${version}";
    sha256 = "sha256-AFy0Ob6caU3yGC9s5Til5sYZ3A4qiEeU96OfeMlR/Q4=";
  };

  vendorSha256 = "sha256-6qfHoP7TOmRZLIiijRfQxyct+486TXQ18cdH8pdhwmQ=";

  outputs = [ "out" "wordlists" ];

  postInstall = ''
    mkdir -p $wordlists
    cp -R examples/wordlists/*.txt $wordlists
    gzip $wordlists/*.txt
  '';

  # https://github.com/OWASP/Amass/issues/640
  doCheck = false;

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
    homepage = "https://owasp.org/www-project-amass/";
    license = licenses.asl20;
    maintainers = with maintainers; [ kalbasit fab ];
  };
}
