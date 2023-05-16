{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "amass";
<<<<<<< HEAD
  version = "4.2.0";
=======
  version = "3.23.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "OWASP";
    repo = "Amass";
<<<<<<< HEAD
    rev = "refs/tags/v${version}";
    hash = "sha256-lhvU2fUnjQ+D+EZDRircNg/np4Ynk+HzOBgxT1L8BaQ=";
  };

  vendorHash = "sha256-PdFIWK4yBh8Bb9mzYdU2h7pDPK8FZMhu8meTd9snP48=";
=======
    rev = "v${version}";
    hash = "sha256-u8ARJZYd+25g3G2MoLWHZd5fgxPsj7Mtx7cROa8VvUA=";
  };

  vendorHash = "sha256-zUl1q6rRjX958VXKnVB2YmLUpKMUtFvdh+hkIrTomes=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  outputs = [
    "out"
    "wordlists"
  ];

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
    changelog = "https://github.com/OWASP/Amass/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ kalbasit fab ];
  };
}
