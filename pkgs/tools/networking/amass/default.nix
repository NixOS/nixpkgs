{ buildGoModule
, fetchFromGitHub
, fetchpatch
, lib
}:

buildGoModule rec {
  pname = "amass";
  version = "2.9.11";

  src = fetchFromGitHub {
    owner = "OWASP";
    repo = "Amass";
    rev = version;
    sha256 = "1mbxxj7cjypxdn80svgmq9yvzaj2x0y1lcbglzzmlqj3r0j265mr";
  };

  modSha256 = "028ln760xaxlsk074x1i5fqi1334rw2bpz7fg520q6m13d9w86hw";

  outputs = [ "out" "wordlists" ];

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
