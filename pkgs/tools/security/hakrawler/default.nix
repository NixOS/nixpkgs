{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "hakrawler";
  version = "20201224-${lib.strings.substring 0 7 rev}";
  rev = "e39a514d0e179d33362ee244c017fb65cc2c12a5";

  src = fetchFromGitHub {
    owner = "hakluke";
    repo = "hakrawler";
    inherit rev;
    sha256 = "0wpqfbpgnr94q5n7i4zh806k8n0phyg0ncnz43hqh4bbdh7l1y8a";
  };

  vendorSha256 = "18zs2l77ds0a3wxfqcd91h269g0agnwhginrx3j6gj30dbfls8a1";

  meta = with lib; {
    description = "Web crawler for the discovery of endpoints and assets";
    homepage = "https://github.com/hakluke/hakrawler";
    longDescription =  ''
      Simple, fast web crawler designed for easy, quick discovery of endpoints
      and assets within a web application.
    '';
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
