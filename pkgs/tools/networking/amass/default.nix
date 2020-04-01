{ buildGoModule
, fetchFromGitHub
, stdenv
, Security
}:

buildGoModule rec {
  pname = "amass";
  version = "3.5.1";

  src = fetchFromGitHub {
    owner = "OWASP";
    repo = "Amass";
    rev = "v${version}";
    sha256 = "1lir0j6av5zl1jb3513cf7mlrydgnsvy0chn5ihg1fvbdiv5lww9";
  };

  modSha256 = "1nahmgzd2akkr0zb80k6s1lz2s1fkggvilwi6bnafwqlaw0qxwcl";

  outputs = [ "out" "wordlists" ];

  buildInputs = stdenv.lib.optionals stdenv.isDarwin [ Security ];

  postInstall = ''
    mkdir -p $wordlists
    cp -R $src/examples/wordlists/*.txt $wordlists
    gzip $wordlists/*.txt
  '';

  meta = with stdenv.lib; {
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
