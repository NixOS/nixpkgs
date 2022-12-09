{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "hakrawler";
  version = "2.1";

  src = fetchFromGitHub {
    owner = "hakluke";
    repo = "hakrawler";
    rev = version;
    hash = "sha256-ZJG5KlIlzaztG27NoSlILj0I94cm2xZq28qx1ebrSmc=";
  };

  vendorSha256 = "sha256-NzgFwPvuEZ2/Ks5dZNRJjzzCNPRGelQP/A6eZltqkmM=";

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
